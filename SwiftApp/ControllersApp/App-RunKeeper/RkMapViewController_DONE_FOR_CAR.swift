//
//  RkMapViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import MapKit

class RkMapViewController: BaseViewController
{
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var selectBox : DbSelectBox! {
        didSet{
            self.selectBox.placeholder = "Chọn vị trí đặc biệt..."
            self.selectBox.dropDownView.tableListHeight = 200
            self.selectBox.dropDownView.hideOptionsWhenTouchOut = true
            self.selectBox.arrowPadding = 10.0
        }
    }
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPace: UILabel!
    
    var mapDelegate: MapDelegate!
    var lastLocationDocMapDownload: LocationDoc? = nil

    var arrLocationDocs: [LocationDoc] = []
    var arrLocationPins: [MapPin] = []
    
    private var pinCurrentUser: MapPin? = nil
    private var distance: Double = 0.0
    private var seconds = 0
    private var timer: Timer?
    private var locationList: [CLLocation] = []
    private var listPolyline: [MKPolyline] = []
    private var isRunning: Bool = false
    
    let locationManager = CLLocationManager()
    
    private var myAnnotation: MKPointAnnotation?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.

        let btnStart = UIBarButtonItem.init(title: "Start", style: .plain) { (owner) in
            if self.isRunning == false {
                // -- Start --
                self.isRunning = true
                owner.title = "Stop"
                self.startRun()
            } else {
                // -- Stop --
                self.isRunning = false
                owner.title = "Start"
                self.stopRun()
            }
        }
        self.navigationItem.rightBarButtonItems =  [btnStart]
        
        // -- Config selectbox --
//        self.selectBox.dropDownView.dataSourceItems([
//            DbDropDownViewItem.init(id: 1, title: "Cột điện"),
//            DbDropDownViewItem.init(id: 2, title: "Đường cầu"),
//            DbDropDownViewItem.init(id: 3, title: "Trạm biến áp"),
//            DbDropDownViewItem.init(id: 4, title: "Công viên"),
//            DbDropDownViewItem.init(id: 5, title: "Nhà nghỉ"),
//            DbDropDownViewItem.init(id: 6, title: "Khách sạn")])
        
        // let arrAnchorLocation = AnchorLocationDoc.er.db_all()
        var arrDataSource: [DbDropDownViewItem] = []
        for anchor in AnchorLocationDoc.er.db_all() {
            let item = DbDropDownViewItem.init(id: anchor.anchorId, title: anchor.anchorName)
            item.rawData = anchor
            arrDataSource.append(item)
        }
        self.selectBox.dropDownView.dataSourceItems(arrDataSource)
        self.selectBox.didSelect { (options, index) in
            print("selectBox: \(options.count) at index: \(index)")
        }
        
        self.requestLocationAccess()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // initialize the map provider (or reset if map type changed in settings)
        initMapProvider();
        
        // Sync locations when we start up
        // This will pull the 100 most recent locations from Cloudant

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // subscribe to locations => tu dong chay luon
        // RkLocationMonitor.instance.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        self.stopRun()

        // stop monitoring locations
        RkLocationMonitor.instance.removeDelegate(self)
    }
    
    // MARK: Map Provider
    
    func initMapProvider()
    {
        self.removeAllLocationPins()
        self.mapDelegate = AppleMapDelegate(mapView: self.mapView!)
        self.mapView?.isHidden = false
        // set style every time
        self.mapDelegate?.setStyle(styleId: "Standard")
    }
    
    func resetMapZoom(lastLocationDoc: LocationDoc)
    {
        let coordinate: CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: lastLocationDoc.latitude, longitude: lastLocationDoc.longitude)
        let latlongMeters = RkAppConstants.initialMapZoomRadiusMiles*RkAppConstants.metersPerMile
        self.mapDelegate?.centerAndZoom(centerCoordinate: coordinate, radiusMeters:latlongMeters, animated:true)
    }
    
    // MARK: Control functions
    
    private func startRun()
    {
        self.seconds = 0
        self.distance = 0
        
        // self.mapView.showsUserLocation = true
        
        // -- Clear all --
        self.removeAllLocations()

        updateDisplay()

        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.eachSecond), userInfo: nil, repeats: true)

        // subscribe to locations
        RkLocationMonitor.instance.addDelegate(self)
    }

    private func stopRun()
    {
        // self.mapView.showsUserLocation = false
        
        // -- Stop scheduledTimer --
        self.timer?.invalidate()
        // stop monitoring locations
        RkLocationMonitor.instance.removeDelegate(self)
    }

    @objc private func eachSecond()
    {
        self.seconds += 1
        self.updateDisplay()
    }

    private func updateDisplay()
    {
        let formattedDistance = FormatDisplay.distance(self.distance)
        let formattedTime = FormatDisplay.time(self.seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds)

        self.lblDistance.text = "Distance:  \(formattedDistance) m"
        self.lblTime.text = "Time:  \(formattedTime) s"
        self.lblPace.text = "Pace:  \(formattedPace) m/s"
    }
    
    private func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: Action functions
    
    @IBAction func btnAdd_Click(_ sender: AnyObject)
    {
        guard let selectedItem = self.selectBox.selectedItem
            , let anchor = selectedItem.rawData as? AnchorLocationDoc else {
                print("Khong tim thay gia tri")
                
                return
        }
        
        if let lastDoc = self.arrLocationDocs.last {
            // -- Make pin --
            let pin = self.mapDelegate!.getPin(
                coordinate: CLLocationCoordinate2DMake(lastDoc.latitude, lastDoc.longitude),
                title: anchor.anchorName,
                color: UIColor.init(hexString: "#"+anchor.hexColor)
            )
            
            self.arrLocationPins.append(pin)
            
            // -- drawPin --
            self.mapDelegate.addPin(pin: pin)
        }
        
        // -- Reset selectedIndex --
        print("\(String(describing: self.selectBox.selectedIndex))")
        self.selectBox.selectedIndex = nil
    }
    
    // MARK: Map Locations
    
    func addLocation(locationDoc: LocationDoc, drawPath: Bool, drawRadius: Bool = false)
    {
        self.arrLocationDocs.append(locationDoc)
        self.addLocationPin(locationDoc: locationDoc, title: "\(self.arrLocationDocs.count)", drawPath: drawPath, drawRadius: drawRadius)
    }
    
    func addLocationPin(locationDoc: LocationDoc, title: String, drawPath: Bool, drawRadius: Bool)
    {
//        let pin = self.mapDelegate!.getPin(
//            coordinate: CLLocationCoordinate2DMake(locationDoc.geometry!.latitude, locationDoc.geometry!.longitude),
//            title: title,
//            color: UIColor.blue
//        )
//        self.locationPins.append(pin)
        
        // -- drawPin --
        // self.mapDelegate.addPin(pin: pin)
        
        if (drawPath) {
            self.drawLocationPath()
        }
        if (drawRadius) {
            self.drawLocationRadius(locationDoc: locationDoc)
        }
    }
    
    func addAllLocationPins()
    {
        for (index,locationDoc) in self.arrLocationDocs.enumerated() {
            self.addLocationPin(locationDoc: locationDoc, title: "\(index+1)" , drawPath: false, drawRadius: false)
        }
        self.drawLocationPath()
    }
    
    func removeAllLocations()
    {
        self.removeAllLocationPins();
        self.arrLocationDocs.removeAll()
    }
    
    func removeAllLocationPins()
    {
        self.mapDelegate?.eraseRadius()
        self.mapDelegate?.erasePath()
//        self.mapDelegate?.removePins(pins: locationPins)
//        self.locationPins.removeAll()
    }
    
    func drawLocationPath()
    {
        // create an array of coordinates from arrLocationDocs
        var coordinates: [CLLocationCoordinate2D] = [];
        
//        for pin: MapPin in self.locationPins {
//            coordinates.append(pin.p_coordinate)
//        }
        
        for docLocation in self.arrLocationDocs {
            coordinates.append(docLocation.location.coordinate)
        }
        
        self.mapDelegate?.drawPath(coordinates: coordinates)
    }
    
    func drawLocationRadius(locationDoc:LocationDoc)
    {
        self.mapDelegate?.drawRadius(centerCoordinate: CLLocationCoordinate2DMake(locationDoc.latitude, locationDoc.longitude), radiusMeters: RkAppConstants.placeRadiusMeters)
    }
    
    func angle(FromCoordinate first:CLLocationCoordinate2D, toCoordinate second:CLLocationCoordinate2D) -> Double
    {
        let deltaLongitude:Double = second.longitude - first.longitude
        let deltaLatitude:Double = second.latitude - first.latitude
        let angle:Double = (Double.pi * 0.5) - atan(deltaLatitude / deltaLongitude)
        
        if deltaLongitude > 0 {
            return angle
        } else if (deltaLongitude < 0) {
            return angle + Double.pi
        } else if (deltaLatitude < 0)  {
            return Double.pi
        }
        return Double.pi
        // return 0.0
    }
    
//    // MARK: Map Places
//
//    func addPlace(placeDoc: PlaceDoc) {
//        var placeExists = false
//        for place in self.placeDocs {
//            if (place.docId == placeDoc.docId) {
//                placeExists = true
//                break
//            }
//        }
//        if (placeExists == false) {
//            self.placeDocs.append(placeDoc)
//            self.addPlacePin(placeDoc: placeDoc)
//        }
//    }
//
//    func addPlacePin(placeDoc: PlaceDoc) {
//        if (self.mapDelegate != nil) {
//            let pin = self.mapDelegate!.getPin(
//                coordinate: CLLocationCoordinate2DMake(placeDoc.geometry!.latitude, placeDoc.geometry!.longitude),
//                title: placeDoc.name!,
//                color: UIColor.green
//            )
//            self.placePins.append(pin)
//            self.mapDelegate!.addPin(pin: pin)
//        }
//    }
//
//    func addAllPlacePins() {
//        for placeDoc: PlaceDoc in self.placeDocs {
//            self.addPlacePin(placeDoc: placeDoc)
//        }
//    }
//
//    func removeAllPlaces() {
//        self.removeAllPlacePins();
//        self.placeDocs.removeAll()
//    }
//
//    func removeAllPlacePins() {
//        self.placePins.removeAll()
//        self.mapDelegate?.removePins(pins: self.placePins)
//    }
    
    
}

extension RkMapViewController: RkLocationMonitorDelegate{
    // MARK: LocationMonitorDelegate Members
    func locationUpdated(bestLocation: CLLocation, locations: [CLLocation], inBackground: Bool)
    {
        // create location document
        let locationDoc = LocationDoc.init(location: bestLocation, timestamp: Date(), background: inBackground)
        
        if self.myAnnotation == nil {
            self.myAnnotation = MKPointAnnotation()
            // Add annotation to map.
            self.myAnnotation!.coordinate = bestLocation.coordinate
            self.mapView.addAnnotation(myAnnotation!)
        }
        
//        if self.pinCurrentUser == nil {
//            self.pinCurrentUser = self.mapDelegate.addCurrentUserPin(coordinate: bestLocation.coordinate)
//        }
        
        if let lastDoc = self.arrLocationDocs.last {
            // -- Tinh toan khoang cach --
            // newLocation.distance(from: lastLocation)
            let delta = bestLocation.distance(from: lastDoc.location) // => convert to meter, con loi chua chay on dinh
            distance = distance + delta
            
            self.myAnnotation!.coordinate = bestLocation.coordinate
            
            // -- Rotation Angle View --
            if let annotationView = self.mapView.view(for: self.myAnnotation!) {
                
                let getAngle = self.angle(FromCoordinate: lastDoc.location.coordinate,
                                          toCoordinate: bestLocation.coordinate)

                UIView.animate(withDuration: 1.0) {
                    annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
                    annotationView.annotation = self.myAnnotation!
                }
            }
            
//            self.mapDelegate.updateCurrentLoctionDirection(forView: self.myAnnotation, from: lastDoc.location.coordinate,
//                                                           to: bestLocation.coordinate)
            
//            self.mapDelegate.updateCurrentLoctionDirection(from: lastDoc.location.coordinate,
//                                                           to: bestLocation.coordinate)
        }
        
        // add location to map
        self.addLocation(locationDoc: locationDoc, drawPath: true, drawRadius: false)
        // reset map zoom
        self.resetMapZoom(lastLocationDoc: locationDoc)
        
        // TODO: save location to datastore
        // TODO: sync places based on latest location
    }
}


//class RkMapViewController: BaseViewController
//{
//    @IBOutlet weak var mapView : MKMapView!
//    @IBOutlet weak var lblDistance: UILabel!
//    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblPace: UILabel!
//
//    var mapDelegate: AppleMapDelegate?
//    var resetZoom = true
//
//    private var distance: Double = 0.0
//    private var seconds = 0
//    private var timer: Timer?
//    private var locationList: [CLLocation] = []
//    private var listPolyline: [MKPolyline] = []
//    private var isRunning: Bool = false
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        self.navigationItem.title = "Run Keeper"
//        self.mapView.delegate = self
//
//        // Do any additional setup after loading the view.
//
//        let rightBarButtonItem_1 = UIBarButtonItem.init(title: "Start", style: .plain) { (owner) in
//            if self.isRunning == false {
//                // -- Start --
//                self.isRunning = true
//                owner.title = "Stop"
//                self.startRun()
//            } else {
//                // -- Stop --
//                self.isRunning = false
//                owner.title = "Start"
//                self.stopRun()
//            }
//        }
//        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1]
//    }
//
//    override func viewDidAppear(_ animated: Bool)
//    {
//        super.viewDidAppear(animated)
//
//        //33.762126, -118.157929
//        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(33.762126, -118.157929), 1000, 1000)
//        self.mapView.setRegion(region, animated: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool)
//    {
//        super.viewWillDisappear(animated)
//
//        self.stopRun()
//
//        // stop monitoring locations
//        RkLocationMonitor.instance.removeDelegate(self)
//    }
//
//    func initMapProvider()
//    {
//        self.resetZoom = true
//        self.mapDelegate = AppleMapDelegate(mapView: self.mapView!)
//        self.mapView.isHidden = false
//        // set style every time
//        self.mapDelegate?.setStyle(styleId: "Standard")
//    }
//
//    func resetMapZoom(coordinate: CLLocationCoordinate2D)
//    {
//        if (self.resetZoom) {
//            self.resetZoom = false
//            self.mapDelegate?.centerAndZoom(centerCoordinate: coordinate, radiusMeters:RkAppConstants.initialMapZoomRadiusMiles*RkAppConstants.metersPerMile, animated:true)
//        }
//    }
//
//
//    private func startRun()
//    {
//        self.seconds = 0
//        self.distance = 0
//
//        for line in self.listPolyline {
//            self.mapView.remove(line)
//        }
//        locationList.removeAll()
//        updateDisplay()
//
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.eachSecond), userInfo: nil, repeats: true)
//
//        // subscribe to locations
//        RkLocationMonitor.instance.addDelegate(self)
//    }
//
//    private func stopRun()
//    {
//        for line in self.listPolyline {
//            self.mapView.remove(line)
//        }
//
//        locationList.removeAll()
//
//        // -- Stop scheduledTimer --
//        self.timer?.invalidate()
//        // stop monitoring locations
//        RkLocationMonitor.instance.removeDelegate(self)
//    }
//
//    @objc private func eachSecond()
//    {
//        self.seconds += 1
//        self.updateDisplay()
//    }
//
//    private func updateDisplay()
//    {
//        let formattedDistance = FormatDisplay.distance(self.distance)
//        let formattedTime = FormatDisplay.time(self.seconds)
//        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds)
//
//        self.lblDistance.text = "Distance:  \(formattedDistance) m"
//        self.lblTime.text = "Time:  \(formattedTime) s"
//        self.lblPace.text = "Pace:  \(formattedPace) m/s"
//    }
//
//}
//
//extension RkMapViewController: RkLocationMonitorDelegate
//{
//    func locationUpdated(bestLocation: CLLocation, locations: [CLLocation], inBackground: Bool)
//    {
//        for newLocation in locations {
//            // let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            // guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
//
//            if let lastLocation = locationList.last {
//                let delta = newLocation.distance(from: lastLocation) // => convert to meter
//                distance = distance + delta //Measurement(value: delta, unit: UnitLength.meters)
//                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
//                let line = MKPolyline(coordinates: coordinates, count: 2)
//                self.listPolyline.append(line)
//                self.mapView.add(line)
//
//                //self.mapView.setCenter(newLocation.coordinate, animated: true)
//                let latlongMeters = RkAppConstants.initialMapZoomRadiusMiles*RkAppConstants.metersPerMile
//                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, latlongMeters,latlongMeters)
//                self.mapView.setRegion(region, animated: true)
//            }
//
//            locationList.append(newLocation)
//        }
//
//    }
//
//}
//
//// MARK: - Map View Delegate
//
//extension RkMapViewController: MKMapViewDelegate
//{
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
//    {
//        guard let polyline = overlay as? MKPolyline else {
//            return MKOverlayRenderer(overlay: overlay)
//        }
//        let renderer = MKPolylineRenderer(polyline: polyline)
//        renderer.strokeColor = .blue
//        renderer.lineWidth = 3
//        return renderer
//    }
//}

