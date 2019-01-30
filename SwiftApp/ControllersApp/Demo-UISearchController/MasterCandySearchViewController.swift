//
//  MasterCandySearchViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/30/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Search Document fo ios >= 11
//  https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
//  Current search for ios >= 9.0

import UIKit

struct Candy {
    let category : String
    let name : String
}

extension UIColor {
    static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
}

class MasterCandySearchViewController: UIViewController
{
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: CandySearchFooter!
    
    var detailViewController: DetailCandySearchViewController? = nil
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Candy Search"
        // Do any additional setup after loading the view.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        self.definesPresentationContext = true
        
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.placeholder = "Search Candies"
        
        if #available(iOS 11.0, *) {
            // The underlying content is obscured during a search.
            self.searchController.obscuresBackgroundDuringPresentation = false
            
            // For iOS 11 and later, place the search bar in the navigation bar.
            self.navigationItem.searchController = self.searchController
            
            // Make the search bar always visible.
            self.navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
        
        // true : the navigation bar should be hidden when searching.
        self.searchController.hidesNavigationBarDuringPresentation = true
        // default: true - the underlying content is dimmed during a search.
        // Always false
        self.searchController.dimsBackgroundDuringPresentation = false // The default is true.
        
        // Setup the Scope Bar
        self.searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        self.searchController.searchBar.delegate = self
        
        // Setup the search footer
        self.tableView.tableFooterView = searchFooter

        self.candies = [
            Candy(category:"Chocolate", name:"Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy Cane"),
            Candy(category:"Hard", name:"Jaw Breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear"),
            Candy(category:"Other", name:"Candy Floss"),
            Candy(category:"Chocolate", name:"Chocolate Coin"),
            Candy(category:"Chocolate", name:"Chocolate Egg"),
            Candy(category:"Other", name:"Jelly Beans"),
            Candy(category:"Other", name:"Liquorice"),
            Candy(category:"Hard", name:"Toffee Apple")]
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailCandySearchViewController
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if let splitViewController = splitViewController {
            if splitViewController.isCollapsed {
                if let selectionIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectionIndexPath, animated: animated)
                }
            }
        }
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        self.filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
            if self.searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        self.tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool
    {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool
    {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

}

extension MasterCandySearchViewController: UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        }
        
        searchFooter.setNotFiltering()
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "SubTitleCell", for: indexPath)
        let reuseIdentifier = "SubTitleCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        let candy: Candy
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell!.textLabel?.text = candy.name
        cell!.detailTextLabel?.text = candy.category
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let candy: Candy
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
    
        let controller = DetailCandySearchViewController()
        controller.detailCandy = candy
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

// MARK: - UISearchBarDelegate
// MARK: -

extension MasterCandySearchViewController: UISearchBarDelegate
{
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        self.filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - UISearchResultsUpdating
// MARK: -

extension MasterCandySearchViewController: UISearchResultsUpdating
{
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        self.filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

