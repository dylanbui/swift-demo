//
//  DemoGgApiViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import GooglePlaces

class DemoGgApiViewController: DbViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //let services: DbGoogleServices = DbGoogleServices.init(apiKey: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE")
        DbGoogleServices.provideAPI(Key: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE")
        let services: DbGoogleServices = DbGoogleServices.shared
        services.securityByBundleId = "vn.propzy.SwiftApp"

        services.requestPlaces("50 nhat") { (arrPlace) in
            print("arrPlace.count = \(arrPlace.count)")
            
            for place in arrPlace {
                print("place.mainAddress = \(place.mainAddress)")
            }

        }
        
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

        

    }



}
