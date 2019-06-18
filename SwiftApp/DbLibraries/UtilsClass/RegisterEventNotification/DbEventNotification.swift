//
//  DbNotification.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/18/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbEventRegisterID = Int

// -- Protocol for AnyObject --
protocol DbEventProtocol : AnyObject {
    
    var eventID: DbEventRegisterID { get set }      //read-write
    
    func startEvent(_ notification: Notification) -> Void
    func cancelEvent() -> Void
    func eventRunBackgroundMode() -> [Notification.Name]
    
    func eventPriority() -> Int
    func eventGroup() -> String
}

// -- Define for optional --
extension DbEventProtocol {
    
    func eventPriority() -> Int {
        return 1;
    }
    
    func eventGroup() -> String {
        return DbEventNotification.Group.UserEvent.rawValue
    }
}

//typealias DbEventObject = Array<DbEventProtocol> // Dung
typealias DbEventObject = DbEventProtocol // Dung

//Since Swift 3:
//typealias CellDelegate = UIPickerViewDataSource & UIPickerViewDelegate

class DbEventIDGenerator {
 
    static var  _nextEventRegisterID: DbEventRegisterID = 0
    
    class func getUniqueRegisterID() -> DbEventRegisterID {
        self._nextEventRegisterID += 1;
        return self._nextEventRegisterID;
    }
}

class DbEventNotification {
    
    enum Group : String {
        case SystemEvent = "SystemEvent"
        case UserEvent = "UserEvent"
    }
    
    // MARK: - Properties
    static let shared = DbEventNotification()
    
    private var arrEventRegisted: [DbEventObject] = []
    private var arrSupportMode: [NSNotification.Name] = []
    
    // Private Initialization
    private init() {
        self.arrEventRegisted = [];
        // -- Default system mode --
        self.arrSupportMode = [
            .MyApplicationIsReady,
            .UIApplicationDidFinishLaunching,
            .UIApplicationDidEnterBackground,
            .UIApplicationWillEnterForeground,
            .UIApplicationDidFinishLaunching,
            .UIApplicationDidBecomeActive,
            .UIApplicationWillResignActive,
            .UIApplicationDidReceiveMemoryWarning,
            .UIApplicationWillTerminate,
            .UIApplicationSignificantTimeChange]
        // -- Start AddObserver --
        self.reAddObserver()
    }
    
    deinit {
        Notification.remove(self)
    }
    
    // MARK: - Functions
    
    func addExtendRunMode(arrMode: Array<NSNotification.Name>) -> Void {
        self.arrSupportMode.append(contentsOf: arrMode)
        // -- Start AddObserver --
        self.reAddObserver()
    }
    
    @discardableResult
    func subscribeEvent(_ event: DbEventObject) -> DbEventRegisterID {
        // -- Add --
        self.arrEventRegisted.append(event);
        // -- Sort --
        self.arrEventRegisted.sort { (event_1, event_2) -> Bool in
            return (event_1.eventPriority() >= event_2.eventPriority())
        }
        // -- Create eventID --
        event.eventID = DbEventIDGenerator.getUniqueRegisterID()
        return event.eventID
    }
    
    func removeEvent(_ event: DbEventObject) -> Void {
        self.removeEventById(eventId: event.eventID)
    }
    
    func removeEventByGroup(eventGroup: String) -> Void {
        for obj: DbEventObject in self.arrEventRegisted {
            if obj.eventGroup() == eventGroup {
                self.removeEventById(eventId: obj.eventID)
            }
        }
    }
    
    func removeEventById(eventId: DbEventRegisterID) -> Void {
        var removeIndex = -1
        for i in 0..<self.arrEventRegisted.count {
            if self.arrEventRegisted[i].eventID == eventId {
                // -- Cancel event --
                self.arrEventRegisted[i].cancelEvent()
                removeIndex = i
                break
            }
        }
        // -- Remove Event --
        self.arrEventRegisted.remove(at: removeIndex)
    }
    
    func removeAllEvent() -> Void {
        for obj: DbEventObject in self.arrEventRegisted {
            obj.cancelEvent()
        }
        self.arrEventRegisted.removeAll()
    }
    
    // MARK: - Private Functions
    
    private func getGroupNameByEventObject(_ eventObj: DbEventObject) -> (String) {
        return eventObj.eventGroup()
    }
    
    private func getPriorityByEventObject(eventObj: DbEventObject) -> Int {
        return eventObj.eventPriority()
    }
    
    private func reAddObserver() -> Void {
        // -- Remove all Notify --
        Notification.remove(self)
        // -- Define all NSNotification --
        for mode: Notification.Name in self.arrSupportMode {
            Notification.add(mode, observer: self, selector: #selector(self.processNotificationCenter), object: nil)
        }
    }
    
    @objc private func processNotificationCenter(notification: Notification) -> Void {
        for obj: DbEventObject in self.arrEventRegisted {
            if obj.eventRunBackgroundMode().contains(notification.name) {
                obj.startEvent(notification)
                // print("\(notification.name.rawValue)")// -------- \(NSStringFromClass(obj))")
            }
        }
    }
}



