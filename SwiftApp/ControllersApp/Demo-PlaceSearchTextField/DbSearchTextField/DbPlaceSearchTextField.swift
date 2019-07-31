//
//  File.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

protocol DbPlaceSearchTextFieldDelegate
{
    func placeSearch(textField owner:DbPlaceSearchTextField, responseForSelectedPlace placeDetail: GgPlaceDetail) -> Void
}


class DbPlaceSearchTextField: DbSearchTextField
{
    public var ggService: DbGoogleServices? = nil
    
    // var strApiKey: String?
    var placeSearchDelegate: DbPlaceSearchTextFieldDelegate?
    
    // MARK: Initializers
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    // MARK: NSCoding
    override open func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit()
    {
        // Set theme - Default: light
        self.theme = DbSearchTextFieldTheme.lightTheme()
        
        //        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        //        footer.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        //        footer.textAlignment = .center
        //        footer.font = UIFont.systemFont(ofSize: 14)
        //        footer.text = "Footer option"
        //        self.resultsListFooter = footer
        
        // Modify current theme properties
        self.theme.font = UIFont.systemFont(ofSize: 16)
        self.theme.fontColor = UIColor.init(95, 95, 95)
        self.theme.subtitleFontColor = UIColor.init(95, 95, 95).withAlphaComponent(0.8)
        self.theme.bgColor = UIColor.white
        self.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.theme.cellHeight = 57
        self.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        self.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        self.maxResultsListHeight = 230
        
        /// Force no filtering (display the entire filtered data source)
        self.forceNoFiltering = true
        
        // Set specific comparision options - Default: .caseInsensitive
        self.comparisonOptions = [.caseInsensitive]
        
        // You can force the results list to support RTL languages - Default: false
        self.forceRightToLeft = false
        
        // Customize highlight attributes - Default: Bold
        self.highlightAttributes = [
            NSAttributedStringKey.backgroundColor: UIColor.yellow,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)
        ]
    }
    
    
    override open func layoutSubviews()
    {
        self.configureCustomSearchTextField()
        
        super.layoutSubviews()
    }
    
    // 2 - Configure a custom search text view
    fileprivate func configureCustomSearchTextField()
    {
        if self.ggService == nil {
            fatalError("DbGoogleServices not found")
        }
        
        // Handle item selection - Default behaviour: item title set to the text field
        self.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            guard let place = filteredResults[itemPosition].rawData as? GgPlace else {
                return
            }
            
            // Do whatever you want with the picked item
            self.text = place.mainAddress
            // -- Search place detail --
            self.ggService?.requestPlaceDetail(place.placeId, result: { (placeDetail) in
                // print("placeDetail.rawData = \(placeDetail.rawData)")
                self.text = placeDetail.formattedAddress
                self.placeSearchDelegate?.placeSearch(textField: self, responseForSelectedPlace: placeDetail)
            })
            
        }
        
        // Update data source when the user stops typing
        self.userStoppedTypingHandler = {
            if let criteria = self.text {
                if criteria.count > 2 {
                    // Show loading indicator
                    self.showLoadingIndicator()
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.filterItems(results)
                        // Stop loading indicator
                        self.stopLoadingIndicator()
                    }
                }
            }
            } as (() -> Void)
    }
    
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [DbSearchTextFieldItem]) -> Void))
    {
        print("criteria = \(criteria)")
        self.ggService?.requestPlaces(criteria, result: { (arrPlace) in
            var results = [DbSearchTextFieldItem]()
            for result: GgPlace in arrPlace {
                let item = DbSearchTextFieldItem(title: result.mainAddress,
                                                 subtitle: result.secondaryAddress,
                                                 image: UIImage(named: "ic_pin_address_white"))
                item.rawData = result
                results.append(item)
            }
            print("==> results.count = \(results.count)")
            callback(results)
        })
    }
    
}

