//
//  DemoGgApiViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import MapKit
import IQKeyboardManagerSwift

class DemoGgApiViewController: DbViewController
{
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var vwAddressContainer: UIView!
    @IBOutlet weak var txtAutoCompletePlace: DbPlaceSearchTextField!
    
    lazy var placesSearchController: DbPlaceSearchViewController = {
        let controller = DbPlaceSearchViewController(delegate: self, ggService: DbGoogleServices.shared,
                                                     searchBarPlaceholder: "Start typing...")
//        let controller = DbPlaceSearchViewController(delegate: self,
//                                                      apiKey: GoogleMapsAPIServerKey,
//                                                      placeType: .address
//            // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
//            // Optional: radius: 10,
//            // Optional: strictBounds: true,
//            // Optional: searchBarPlaceholder: "Start typing..."
//        )
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "AutoComplete Place"
        
        // self.edgesForExtendedLayout = []
        
        // -- Set frame zoom --
        let pzLocation = CLLocationCoordinate2D(latitude: DEF_LAT, longitude: DEF_LONG)
//        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion.init(center: pzLocation, span: span)
//        self.mapView.setRegion(region, animated: false)
        self.mapView.setCenterCoordinate(pzLocation, withZoomLevel: 18, animated: false)
        // self.mapView.delegate = self
        
        // -- Define AutoCompletePlace --
        DbGoogleServices.provideAPI(Key: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE", BundleId: "vn.propzy.SwiftApp")
        // let services: DbGoogleServices = DbGoogleServices.shared
        self.txtAutoCompletePlace.ggService = DbGoogleServices.shared
        self.txtAutoCompletePlace.containerView = self.vwAddressContainer
        self.txtAutoCompletePlace.tableCornerRadius = 6
        
        // -- Run asynchronous --
        self.perform(#selector(self.initGolbalParams), on: .main, with: nil, waitUntilDone: false)
    }
    
    @objc private func initGolbalParams() -> Void
    {
        // -- Get real size of UIView --
        // -- Define AutoCompletePlace--
        self.defineAutoCompletePlace()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // -- Config IQKeyboardManager only this controller --
        // -- Conflicts with txtAutoCompletePlace when you choose row --
        // -- Hide keyboard toolbar --
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // -- Remove Conflicts with txtAutoCompletePlace when you choose row --
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }

//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//
//        //let services: DbGoogleServices = DbGoogleServices.init(apiKey: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE")
//        // DbGoogleServices.provideAPI(Key: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE")
//        DbGoogleServices.provideAPI(Key: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE", BundleId: "vn.propzy.SwiftApp")
//        let services: DbGoogleServices = DbGoogleServices.shared
//        // services.securityByBundleId = "vn.propzy.SwiftApp"
//
//        services.requestPlaces("50 nhat") { (arrPlace) in
//            print("arrPlace.count = \(arrPlace.count)")
//
//            for place in arrPlace {
//                print("place.mainAddress = \(place.mainAddress)")
//            }
//
//        }
    
//        let placesClient = GMSPlacesClient.shared()
//
//        placesClient.autocompleteQuery("50 nhat", bounds: nil, filter: nil, callback: { (results, error) in
//
//            print("ERROR : \(error?.localizedDescription)")
//
//            DispatchQueue.main.async {
//
//                if results != nil {
//                    for result in results!{
//                        print("-- \(result.placeID)")
//                        print("-- \(result.attributedFullText.string)")
//                        print("-- \(result.attributedPrimaryText.string)")
//                        print("-- \(result.attributedSecondaryText?.string ?? "")")
//                    }
//                }
//            }
//        })
//    }
    
    @IBAction func btnPlaceViewController_Click(_ sender: AnyObject)
    {
        self.present(self.placesSearchController, animated: true, completion: nil)
    }

    // MARK: - Private Functions
    
    private func defineAutoCompletePlace() -> Void
    {
        // -- AutoCompletePlace Properties --
        let footerView = UIView.init(frame: CGRect(0, 0, self.vwAddressContainer.width, 40))
        footerView.backgroundColor = UIColor(hexString: "#f8f8f8")
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(10, 5, 250, 30)
        btn.setTitle("Không tìm thấy địa chỉ?", for: .normal)
        btn.setTitleColor(UIColor(63, 63, 63), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.titleLabel?.attributedText = btn.titleLabel?.text?.db_underline
        btn.contentHorizontalAlignment = .left
        btn.onTap { (tap) in
            // btnNotFound_Click
            self.view.endEditing(true)
        }
        footerView.addSubview(btn)
        self.txtAutoCompletePlace.resultsListSectionFooter = footerView
        self.txtAutoCompletePlace.placeSearchDelegate = self
        
    }

    private func showDebug(placeDetail: GgPlaceDetail)
    {
        let address = placeDetail.formattedAddress
        let strCity = placeDetail.getAddressComponentsWithDefines(.kGGPlaceDetailCity)
        let strDistrict = placeDetail.getAddressComponentsWithDefines(.kGGPlaceDetailDistrict)
        let strWard = placeDetail.getAddressComponentsWithDefines(.kGGPlaceDetailCustomWard)
        let houseNumberRoad = placeDetail.getAddressComponentsWithDefines(.kGGPlaceDetailAddress)
        
        let coordinate = placeDetail.location.coordinate
        
        print("address = \(address)")
        print("strCity = \(strCity)")
        print("strDistrict = \(strDistrict)")
        print("strWard = \(strWard)")
        print("houseNumberRoad = \(houseNumberRoad)")
        print("coordinate = \(coordinate)")
    }
    

}

extension DemoGgApiViewController: DbPlaceSearchViewControllerDelegate
{
    func viewController(didAutocompleteWith placeDetail: GgPlaceDetail)
    {
        self.showDebug(placeDetail: placeDetail)
        self.placesSearchController.isActive = false
    }
}

// MARK: - PlaceSearchTextFieldDelegate
// MARK: -

extension DemoGgApiViewController: DbPlaceSearchTextFieldDelegate
{
    func placeSearch(textField owner: DbPlaceSearchTextField, responseForSelectedPlace placeDetail: GgPlaceDetail)
    {
        // -- Hide keyboard --
        self.view.endEditing(true)
        
        self.showDebug(placeDetail: placeDetail)
        
        let coordinate = placeDetail.location.coordinate
        // -- Move to location --
        self.mapView.setCenterCoordinate(coordinate, withZoomLevel: 18, animated: true)
    }
    
   
    
   
    
}
