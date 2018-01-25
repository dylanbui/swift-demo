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
        
        let location = LocationManager.sharedInstance()

        // Do any additional setup after loading the view.
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                            if (status == INTULocationStatus.success) {
                                                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                // currentLocation contains the device's current location
                                            }
                                            else if (status == INTULocationStatus.timedOut) {
                                                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                // However, currentLocation contains the best location available (if any) as of right now,
                                                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                            }
                                            else {
                                                // An error occurred, more info is available by looking at the specific status returned.
                                            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
