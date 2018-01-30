//
//  FirstViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import INTULocationManager

class FirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationBarHiddenForThisController()
        
        let dictionary = [
            "A" : [1, 2],
            "Z" : [3, 4],
            "D" : [5, 6]
        ]
        
        // let sortedKeys = Array(dictionary.keys).sorted(by: { $0.0 < $1.0 })
        let sortedDict = dictionary.sorted(by: { $0.0 < $1.0 })
        print("sortedDict = \(sortedDict)")
        
        // -- Sort arr with var --
        var sortedKeys = Array(dictionary.keys)
        // sortedKeys.sort()
        sortedKeys.sort(by: >)
        print("sortedKeys = \(sortedKeys)")
        
        let service = ServiceUrl.shared
        service.addChangeModeControl(self.view, selectHandle: { (serviceMode) in
            print("serviceMode after = \(serviceMode.name)")
            print("serviceMode.configData = \(serviceMode.configData)")
            
            print("service.serverMode = \(service.getServiceUrl(ServerKey.API_BASE_URL_KEY))")
            print("service.serverMode = \(service.serverMode.name)")
        })

        
//        let location = LocationManager.sharedInstance()
//
//        // Do any additional setup after loading the view.
//        let locationManager = INTULocationManager.sharedInstance()
//        locationManager.requestLocation(withDesiredAccuracy: .city,
//                                        timeout: 10.0,
//                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
//                                            if (status == INTULocationStatus.success) {
//                                                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
//                                                // currentLocation contains the device's current location
//                                            }
//                                            else if (status == INTULocationStatus.timedOut) {
//                                                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
//                                                // However, currentLocation contains the best location available (if any) as of right now,
//                                                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
//                                            }
//                                            else {
//                                                // An error occurred, more info is available by looking at the specific status returned.
//                                            }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnButton_Click(_ sender: UIButton) {
        
        if sender.tag == 4 {
            let sas = DbSelectorActionSheet(title: "Chon server", dismissButtonTitle: "Chon print", otherButtonTitles: ["Server Dev", "Server Test", "Server Prodution"])

            sas.showIn(self, selectorActionSheetBlock: { (selectedIndex, show) in
                print("da chon : \(selectedIndex)")
            })
            
        }
        
        
        if sender.tag == 1 {
            DbAlertController.alert("Title string", message: "Alert message")
        } else if sender.tag == 2 {
            
            // With individual UIAlertAction objects
            let firstAction = UIAlertAction(title: "First Button", style: .cancel, handler: { (UIAlertAction) -> Void in
                print("firstAction pressed")
            })
//            firstAction.setValue(UIColor.blue, forKey: "titleTextColor")
            
            let secondAction = UIAlertAction(title: "Second Button", style: .destructive, handler: { (UIAlertAction) -> Void in
                print("secondAction pressed")
            })
//            secondAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            DbAlertController.alert("Title", message: "Message", buttons: [firstAction, secondAction], tapBlock: { (alertAction, indexAction) in
                print("DbAlertController === indexAction = \(indexAction)")
            })
            
//            DbAlertController.alert("Title", message: "Message", buttons: ["First", "Second"], tapBlock: { (alertAction, indexAction) in
//                print("indexAction = \(indexAction)")
//            })
        } else if sender.tag == 3 {
            
            // With individual UIAlertAction objects
            let firstButtonAction = UIAlertAction(title: "First Button", style: .default, handler: { (UIAlertAction) -> Void in
                print("First Button pressed")
            })
            firstButtonAction.setValue(UIColor.blue, forKey: "titleTextColor")
            
            let secondButtonAction = UIAlertAction(title: "Second Button", style: .default, handler: { (UIAlertAction) -> Void in
                print("Second Button pressed")
            })
            secondButtonAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            DbAlertController.actionSheet("Title", message: "message", sourceView: self.view, actions: [firstButtonAction, secondButtonAction])
            
            
        }
    }



}
