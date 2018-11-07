//
//  DbAppDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/16/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications

//@UIApplicationMain
class DbAppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    // MARK: -
    var window: UIWindow?
//    var rootViewController: DbViewController?
    var rootViewController: UIViewController?
    
    // MARK: - Functions
    // MARK: -
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.registerForRemoteNotification()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func registerForRemoteNotification() {
        if Db.isSimulator() {
            return
        }
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = (self as UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
        // -- Save deviceTokenString to UserDefaults --
        UserDefaults.setObject(key: DB_DEVICE_PUSH_TOKEN, value: deviceTokenString)
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
//    #pragma mark -
//    #pragma mark Register Notification
//    #pragma mark -
//
//    /** Notification Registration */
//    - (void)registerForRemoteNotification
//    {
//    if (IS_SIMULATOR)
//    return;
//
//    // -- New code for ios 10 --
//    // -- http://ashishkakkad.com/2016/09/push-notifications-in-ios-10-objective-c/ --
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
//    completionHandler:^(BOOL granted, NSError * _Nullable error){
//    if( !error ){
//    // -- [UIApplication registerForRemoteNotifications] must be used from main thread only --
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    });
//    }
//    }];
//    }
//    else {
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    }
//
//    #pragma mark -
//    #pragma mark Register Notification Key
//    #pragma mark -
//
//    - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//    {
//    [application registerForRemoteNotifications];
//    }
//
//    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//    {
//    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    NSLog(@"Device Token = %@",strDevicetoken);
//    [[DbAppSession instance] setDevicePushNotificationToken:strDevicetoken];
//    }
//
//    - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//    {
//    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
//    NSLog(@"Error = %@",error);
//    }
    
    // -- Remote Notification Delegate // <= iOS 9.x --
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        var dictUserInfo = userInfo
        dictUserInfo["applicationState"] = UIApplication.shared.applicationState // UIApplicationState
        dictUserInfo["clickState"] = true

        if UIApplication.shared.applicationState == .active {
            // Play sound
            AudioServicesPlaySystemSound(1007)
            // -- Kiem tra coi co can hien thong bao ko --
            dictUserInfo["clickState"] = false
            Notification.post(Notification.Name.MyApplicationServerPushMessage, object: self, userInfo: userInfo)
            return
        }
        
        DbUtils.performAfter(delay: 0.5) {
            Notification.post(Notification.Name.MyApplicationServerPushMessage, object: self, userInfo: userInfo)
        }
        
        completionHandler(.noData)
    }
}

// -- Remote Notification Delegate // >= iOS 10.x --

// [START ios_10_message_handling]
@available(iOS 10, *)
extension DbAppDelegate : UNUserNotificationCenterDelegate
{
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print(userInfo)
        
        // Play sound
        AudioServicesPlaySystemSound(1007)
        
        userInfo["applicationState"] = UIApplication.shared.applicationState // UIApplicationState
        userInfo["clickState"] = false
        
        Notification.post(Notification.Name.MyApplicationServerPushMessage, object: self, userInfo: userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.sound, .alert, .badge])
    }
    
    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        var userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
        userInfo["applicationState"] = UIApplication.shared.applicationState // UIApplicationState
        userInfo["clickState"] = true
        
        DbUtils.performAfter(delay: 0.25) {
            Notification.post(Notification.Name.MyApplicationServerPushMessage, object: self, userInfo: userInfo)
        }
    }
}
// [END ios_10_message_handling]

