//
//  DbPlaceSearchViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public protocol DbPlaceSearchViewControllerDelegate: class
{
    func viewController(didAutocompleteWith place: GgPlaceDetail)
}

open class DbPlaceSearchViewController: UISearchController
{
    private var ggService: DbGoogleServices?
    private weak var placeDelegate: DbPlaceSearchViewControllerDelegate?
    
    convenience public init(delegate: DbPlaceSearchViewControllerDelegate, ggService: DbGoogleServices,
                            locationBias: GgLocationBias? = nil, searchBarPlaceholder: String = "Nhập địa chỉ ...")
    {
        let gpaViewController = GooglePlacesAutocompleteContainer.init(delegate: delegate, ggService: ggService,
                                                                       locationBias: locationBias)
        gpaViewController.view.backgroundColor = UIColor.white
        
        self.init(searchResultsController: gpaViewController)
        
        self.ggService = ggService
        self.placeDelegate = delegate
        
        self.searchResultsUpdater = gpaViewController
        self.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchBar.placeholder = searchBarPlaceholder
        self.searchBar.delegate = self
        
        // -- Show get current location address --
        self.searchBar.showsBookmarkButton = true
        self.searchBar.setImage(UIImage(named: "ic_current_location"), for: .bookmark, state: .normal)
        // -- Demo show more button --
        // self.searchBar.scopeButtonTitles =  ["Friends", "Everyone"]
        
        // -- Set background color --
        // self.view.backgroundColor = UIColor.white
    }
}

extension DbPlaceSearchViewController: UISearchBarDelegate
{
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        manager.getCurrentLocation(withCompletion: { success, dictLocation, error in
            
            if let err = error {
                print("Error = \(err)")
                return
            }
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(
                (dictLocation[DB_LATITUDE] as? NSNumber)!.doubleValue,
                (dictLocation[DB_LONGITUDE] as? NSNumber)!.doubleValue)

            // Geocoding API - Convert between addresses and geographic coordinates.
            self.ggService?.retrieveAddressInfoFromLocation(coordinate, withCompletion: { (placeDetail) in
                self.placeDelegate?.viewController(didAutocompleteWith: placeDetail)
            })
        })

    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        print("New scope index is now \(selectedScope)")
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print("searchText = \(searchText)")
    }

    
}

open class GooglePlacesAutocompleteContainer: UITableViewController
{
    private weak var delegate: DbPlaceSearchViewControllerDelegate?
    private var ggService: DbGoogleServices
    private var locationBias: GgLocationBias?
    
    private lazy var vwCurrentLocation: UIView = {
        // -- Get current location --
        let footerView = UIView.init(frame: CGRect.zero)
        footerView.backgroundColor = UIColor(hexString: "#f8f8f8")
        
        let btn = UIButton(type: .custom)
        btn.frame = footerView.bounds
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        btn.setTitle("Vị trí hiện tại?", for: .normal)
        btn.setTitleColor(UIColor(63, 63, 63), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.titleLabel?.attributedText = btn.titleLabel?.text?.db_underline
        btn.contentHorizontalAlignment = .right
        btn.onTap { (tap) in
            self.getFromCurrentLocation()
        }
        footerView.addSubview(btn)

        return footerView
    }()
    
    private let cellIdentifier = "Cell"
    
    private var places = [GgPlace]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Add a search text throttle property to your controller
    private let queueThrottle = DbQueue.global(.background)
    
    public init(delegate: DbPlaceSearchViewControllerDelegate,
                ggService: DbGoogleServices,
                locationBias: GgLocationBias? = nil)
    {
        // self.init()
        self.delegate = delegate
        self.ggService = ggService
        self.locationBias = locationBias
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getFromCurrentLocation()
    {
        print("Get location")
    }
}

extension GooglePlacesAutocompleteContainer
{
    // -- Display section view show current location --
//    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 40.0
//    }
//
//    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        return self.vwCurrentLocation
//    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return places.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let place = places[indexPath.row]
        
        cell.textLabel?.text = place.mainAddress
        cell.detailTextLabel?.text = place.secondaryAddress
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let place = places[indexPath.row]
        
        // -- Search place detail --
        self.ggService.requestPlaceDetail(place.placeId, result: { (placeDetail) in
            // print("placeDetail.rawData = \(placeDetail.rawData)")
            self.delegate?.viewController(didAutocompleteWith: placeDetail)
        })
    }
}

extension GooglePlacesAutocompleteContainer: UISearchResultsUpdating
{
    
    @objc fileprivate func searchInBackground(_ criteria: String)
    {
        if criteria.count < 2 {
            return
        }

        print("criteria = \(criteria)")
        self.ggService.requestPlaces(criteria, locationBias: self.locationBias, result: { (arrPlace) in
            print("==> arrPlace.count = \(arrPlace.count)")
            self.places = arrPlace
        })
    }
    
    public func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { places = []; return }
        
        // Debug: hit text only run in here
        queueThrottle.throttle(deadline: DispatchTime.now() + 0.75) {
            self.searchInBackground(searchText)
        }
    }
}


