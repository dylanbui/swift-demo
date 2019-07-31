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

open class DbPlaceSearchViewController: UISearchController, UISearchBarDelegate
{
    convenience public init(delegate: DbPlaceSearchViewControllerDelegate, ggService: DbGoogleServices,
                            locationBias: GgLocationBias? = nil, searchBarPlaceholder: String = "Enter Address")
    {
        let gpaViewController = GooglePlacesAutocompleteContainer.init(delegate: delegate, ggService: ggService,
                                                                       locationBias: locationBias)
        gpaViewController.view.backgroundColor = UIColor.white
        
        
        self.init(searchResultsController: gpaViewController)
        
        self.searchResultsUpdater = gpaViewController
        self.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchBar.placeholder = searchBarPlaceholder
        
        // -- Set background color --
        // self.view.backgroundColor = UIColor.white
    }
}

open class GooglePlacesAutocompleteContainer: UITableViewController
{
    private weak var delegate: DbPlaceSearchViewControllerDelegate?
    private var ggService: DbGoogleServices
    private var locationBias: GgLocationBias?
    
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
}

extension GooglePlacesAutocompleteContainer
{
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

extension GooglePlacesAutocompleteContainer: UISearchBarDelegate, UISearchResultsUpdating
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
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard !searchText.isEmpty else { places = []; return }
        
        queueThrottle.throttle(deadline: DispatchTime.now() + 0.75) {
            self.searchInBackground(searchText)
        }
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


