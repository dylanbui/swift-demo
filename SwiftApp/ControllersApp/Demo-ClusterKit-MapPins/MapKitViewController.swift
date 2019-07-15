//
//  MapKitViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import MapKit
import ClusterKit

public let CKMapViewDefaultAnnotationViewReuseIdentifier = "annotation"
public let CKMapViewDefaultClusterAnnotationViewReuseIdentifier = "cluster"

class MapKitViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    
    
    var searchParam: PropertySearchParam?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 200
        
        // MKPointAnnotation
        
        self.mapView.delegate = self
        self.mapView.clusterManager.algorithm = algorithm
        self.mapView.clusterManager.marginFactor = 1
        
        // -- Set frame zoom --
        let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let pzLocation = CLLocationCoordinate2D(latitude: DEF_LAT, longitude: DEF_LONG)
        let region = MKCoordinateRegion.init(center: pzLocation, span: span)
        self.mapView.setRegion(region, animated: false)
        // self.mapView.setCenter(propzy, animated: false)
        
        self.searchParam = PropertySearchParam()
        self.searchParam?.pagingAtPage = 1
        self.searchParam?.pagingWithLimit = 1000
        
        PropertySearchApi.getPropertiesMapPin(searchParam: self.searchParam!) { (success, totalItems, arrPin) in
            if Thread.isMainThread {
                print("MMAIN THREAD")
            } else {
                print("SUBBBB THREAD")
            }
            
            if !success {
                print("Loi me no roi")
                return
            }
            
            print("totalItems = \(totalItems)")
            
            DbDispatch.asyncMain {
                // -- Load du lieu trong Main Thread --
                self.mapView.clusterManager.annotations = arrPin
                self.mapView.clusterManager.addAnnotations(<#T##annotations: [MKAnnotation]##[MKAnnotation]#>)
            }
        }
        
    }
    
}

extension MapKitViewController: MKMapViewDelegate
{
   
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let cluster = annotation as? CKCluster else {
            return nil
        }
        
        if cluster.count > 1 {
            // -- Group --
            return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier) ??
                CKClusterView(annotation: annotation, reuseIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        // -- Detail --
        return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier) ??
            CKAnnotationView(annotation: annotation, reuseIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    // MARK: - How To Update Clusters
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.mapView.clusterManager.updateClustersIfNeeded()
    }
    
    // MARK: - How To Handle Selection/Deselection
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let cluster = view.annotation as? CKCluster else {
            return
        }
        
        if cluster.count > 1 {
            let edgePadding = UIEdgeInsets.init(top: 40, left: 20, bottom: 44, right: 20)
            self.mapView.show(cluster, edgePadding: edgePadding, animated: true)
        } else if let annotation = cluster.firstAnnotation {
            self.mapView.clusterManager.selectAnnotation(annotation, animated: false);
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        guard let cluster = view.annotation as? CKCluster, cluster.count == 1 else {
            return
        }
        
        self.mapView.clusterManager.deselectAnnotation(cluster.firstAnnotation, animated: false);
    }
    
    // MARK: - How To Handle Drag and Drop
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState)
    {
        guard let cluster = view.annotation as? CKCluster else {
            return
        }
        
        switch newState {
        case .ending:
            
            if let annotation = cluster.firstAnnotation as? MKPointAnnotation {
                annotation.coordinate = cluster.coordinate
            }
            view.setDragState(.none, animated: true)
            
        case .canceling:
            view.setDragState(.none, animated: true)
            
        default: break
            
        }
    }


}


class CKAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        isDraggable = true
        image = UIImage(named: "marker")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}

//class CKClusterView: MKAnnotationView
//{
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        image = UIImage(named: "cluster")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("Not implemented")
//    }
//}

class CKClusterView: MKAnnotationView
{
    open lazy var countLabel: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .red //.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.baselineAdjustment = .alignCenters
        self.addSubview(label)
        return label
    }()
    
    open override var annotation: MKAnnotation? {
        didSet {
            configure()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = UIImage(named: "cluster")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Not implemented")
    }
    
    open func configure()
    {
        guard let cluster = annotation as? CKCluster else { return }
        let count = cluster.count
        countLabel.text = "\(count)"
    }
}


extension MKMapView
{
    var northWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY).coordinate
    }
    
    var northEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.minY).coordinate
    }
    
    var southEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.maxY).coordinate
    }
    
    var southWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.maxY).coordinate
    }
}
