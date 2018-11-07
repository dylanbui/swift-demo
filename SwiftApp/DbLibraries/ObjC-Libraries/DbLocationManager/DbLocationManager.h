//
//  DbLocationManager.h
//  ObjcApp
//
//  Created by Dylan Bui on 5/4/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/benzamin/BBLocationManager
//  Co diem kem la khi Allow cho truy cap location thi ko lay du lieu ngay ma user phai bam lai lan nua

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static const CLLocationAccuracy kDbHorizontalAccuracyThresholdCity =         5000.0;  // in meters
static const CLLocationAccuracy kDbHorizontalAccuracyThresholdNeighborhood = 1000.0;  // in meters
static const CLLocationAccuracy kDbHorizontalAccuracyThresholdBlock =         100.0;  // in meters
static const CLLocationAccuracy kDbHorizontalAccuracyThresholdHouse =          15.0;  // in meters
static const CLLocationAccuracy kDbHorizontalAccuracyThresholdRoom =            5.0;  // in meters

#define DB_FENCE_EVENT_TYPE_KEY @"DBeventType"
#define DB_FENCE_EVENT_TIMESTAMP_KEY @"DBeventTimeStamp"
#define DB_FENCE_IDENTIFIER_KEY @"DBfenceIDentifier"
#define DB_FENCE_COORDINATE_KEY @"DBfenceCoordinate"

#define DB_GET_FENCE_EVENT_STRING(fenceEventTypeEnum) [@[ @"DbFenceEventAdded", @"DbFenceEventRemoved",@"DbFenceEventFailed", @"DbFenceEventRepeated", @"DbFenceEventEnterFence",@"DbFenceEventExitFence", @"DbFenceEventNone"] objectAtIndex:(fenceEventTypeEnum)]

typedef enum : NSUInteger {
    DbFenceEventTypeAdded,
    DbFenceEventTypeRemoved,
    DbFenceEventTypeFailed,
    DbFenceEventTypeRepeated,
    DbFenceEventTypeEnterFence,
    DbFenceEventTypeExitFence,
    DbFenceEventTypeNone
} DbFenceEventType;

@interface DbFenceInfo : NSObject

@property(nonatomic, assign) NSString *eventType;
@property(nonatomic, strong) NSString *eventTimeStamp;
@property(nonatomic, strong) NSString *fenceIDentifier;
@property(nonatomic, strong) NSDictionary *fenceCoordinate;//uses DB_LATITUDE,  DB_LONGITUDE, DB_RADIOUS to wrap data

- (NSDictionary*)dictionary;

@end


#define DB_DEFAULT_FENCE_RADIOUS 100.0f
#define DB_LOCATION @"location"
#define DB_LATITUDE @"latitude"
#define DB_LONGITUDE @"longitude"
#define DB_ALTITUDE @"altitude"
#define DB_RADIOUS @"DBRadious"

#define DB_ADDRESS_NAME @"address_name"         // eg. Apple Inc.
#define DB_ADDRESS_STREET @"address_street"     // street name, eg. Infinite Loop
#define DB_ADDRESS_CITY @"address_city"         // city, eg. Cupertino
#define DB_ADDRESS_STATE @"address_state"       // state, eg. CA
#define DB_ADDRESS_COUNTY @"address_county"     // county, eg. Santa Clara
#define DB_ADDRESS_ZIPCODE @"address_zipcode"   // zip code, eg. 95014
#define DB_ADDRESS_COUNTRY @"address_country"   // eg. United States
#define DB_ADDRESS_DICTIONARY @"address_full_dictionary"  //total "addressDictionary" of "CLPlacemark" object


typedef void(^LocationUpdateBlock)(BOOL success, NSDictionary *locationDictionary, NSError *error);
typedef void(^GeoCodeUpdateBlock)(BOOL success, NSDictionary *geoCodeDictionary, NSError *error);

@protocol DbLocationManagerDelegate <NSObject>
@required
/**
 *   Gives an Location Dictionary using keys "latitude", "longitude" and "altitude". You can use these macros: DB_LATITUDE, DB_LONGITUDE and DB_ALTITUDE.
 *   Sample output dictionary @{ @"latitude" : 23.6850, "longitude" : 90.3563, "altitude" : 10.4604}
 */
-(void)DbLocationManagerDidUpdateLocation:(NSDictionary *)latLongAltitudeDictionary;

@optional
/**
 *   Gives an DbFenceInfo Object of the Fence which just added
 */
-(void)DbLocationManagerDidAddFence:(DbFenceInfo *)fenceInfo;


/**
 *   Gives an DbFenceInfo Object of the Fence which just failed to monitor
 */
-(void)DbLocationManagerDidFailedFence:(DbFenceInfo *)fenceInfo;


/**
 *   Gives an DbFenceInfo Object of a Fence just entered
 */
-(void)DbLocationManagerDidEnterFence:(DbFenceInfo *)fenceInfo;


/**
 *   Gives an DbFenceInfo Object of a Exited Fence
 */
-(void)DbLocationManagerDidExitFence:(DbFenceInfo *)fenceInfo;


/**
 *   Gives an Dictionary using current geocode or adress information with DB_ADDRESS_* keys
 */
-(void)DbLocationManagerDidUpdateGeocodeAdress:(NSDictionary *)addressDictionary;


@end

@interface DbLocationManager : NSObject
{
    
    __weak id <DbLocationManagerDelegate> _delegate;
}

/**
 *  The delegate, using this the location events are fired.
 */
@property (nonatomic, weak) id <DbLocationManagerDelegate> delegate;

/**
 *  The last known Geocode address determinded, will be nil if there is no geocode was requested.
 */
@property (nonatomic, strong) NSDictionary *lastKnownGeocodeAddress;

/**
 *  The last known location received. Will be nil until a location has been received. Returns an Dictionary using keys DB_LATITUDE, DB_LONGITUDE, DB_ALTITUDE
 */
@property (nonatomic, strong) NSDictionary *lastKnownGeoLocation;

/**
 *  Similar to lastKnownLocation, The last location received. Will be nil until a location has been received. Returns an Dictionary using keys DB_LATITUDE, DB_LONGITUDE, DB_ALTITUDE
 */
@property (nonatomic, strong) NSDictionary *location;

/**
 *   The desired location accuracy in meters. Default is 100 meters.
 *<p>
 *The location service will try its best to achieve
 your desired accuracy. However, it is not guaranteed. To optimize
 power performance, be sure to specify an appropriate accuracy for your usage scenario (eg, use a large accuracy value when only a coarse location is needed). Set it to 0 to achieve the best possible accuracy.
 *</p>
 */
@property(nonatomic, assign) double desiredAcuracy;

/**
 *  Specifies the minimum update distance in meters. Client will not be notified of movements of less
 than the stated value, unless the accuracy has improved. Pass in 0 to be
 notified of all movements. By default, 100 meters is used.
 */
@property(nonatomic, assign) double distanceFilter;

/**
 *   Returns a singeton(static) instance of the DbLocationManager
 *   <p>
 *   Returns a singeton(static) instance of the DbLocationManager
 *   </p>
 *   @return singeton(static) instance of the DbLocationManager
 */
+ (instancetype)sharedManager;


/**
 *   Returns location permission status
 *   <p>
 *   Returns wheather location is permitted or not by the user
 *   </p>
 *
 *   @return true or false based on permission given or not
 */
+ (BOOL)locationPermission;

/**
 *   Prompts user for location permission
 *   <p>
 *   If user havn't seen any permission requests yet, calling this method will ask user for location permission
 *   For knowing permission status, call the @locationPermission method
 *   </p>
 */
- (BOOL)getPermissionForStartUpdatingLocation;

/**
 *   Gives an Array of dictionary formatted DbFenceInfo which are currently active
 *   <p>
 *   Gives an Array of dictionary formatted DbFenceInfo which are currently active
 *   </p>
 *   @return an Array of dictionary formatted DbFenceInfo
 */
- (NSArray*)getCurrentFences;

/**
 *   Delete all the fences which are currently active.
 *   <p>
 *   Those fences we created and are currently active, delete all of'em.
 *   </p>
 */
- (void)deleteCurrentFences;

/**
 *   Simple request location. Only run when get location sucessfully
 */
- (void)requestLocation:(void (^)(CLLocation *currentLocation))completionHandler;

/**
 *   Returns current location through the DbLocationManagerDelegate, can be adjusted using the desiredAcuracy and distanceFilter properties.
 *   <p>
 *   Gives location of device using delegate DbLocationManagerDidUpdateLocation:
 *   </p>
 *   @param delegate where the location will be delivered, which implements DbLocationManagerDelegate
 */
- (void)getCurrentLocationWithDelegate:(id)delegate;

/**
 *   Returns current location, can be adjusted using the desiredAcuracy and distanceFilter properties.
 *   <p>
 *   Gives location of device using the completion block
 *   </p>
 *   @param completion : A block which will be called when the location is updated
 */
- (void)getCurrentLocationWithCompletion:(LocationUpdateBlock)completion skipAuthAlert:(BOOL)skipAlert;

/**
 *   Returns current location, can be adjusted using the desiredAcuracy and distanceFilter properties.
 *   <p>
 *   Gives location of device using the completion block
 *   </p>
 *   @param completion : A block which will be called when the location is updated
 */
- (void)getCurrentLocationWithCompletion:(LocationUpdateBlock)completion;


/**
 *   Returns current location's geocode address
 *   <p>
 *   Gives the currents location's geocode addres using DbLocationManagerDelegate, uses Apple's own geocode API to get teh current address
 *   </p>
 *   @return DbLocationManagerDidUpdateGeocodeAdress is called when the location and geocode is updated
 */
- (void)getCurrentGeocodeAddressWithDelegate:(id)delegate;

/**
 *   Returns current location's geocode address
 *   <p>
 *   Gives the currents location's geocode addres using given block, uses Apple's own geocode API to get teh current address
 *   </p>
 *   @return Callback block is called when the location and geocode is updated
 */
- (void)getCurrentGeoCodeAddressWithCompletion:(GeoCodeUpdateBlock)completion;


/**
 *   Returns current location continiously through DbLocationManagerDidUpdateLocation method, can be adjusted using the desiredAcuracy and distanceFilter properties.
 *   <p>
 *   Gives the current location continiously until the -stopGettingLocation is called
 *   </p>
 *   @return Callback block is called when the location and geocode is updated
 */
-(void)getContiniousLocationWithDelegate:(id)delegate;

/**
 *   Start monitoring significant location changes.  The behavior of this service is not affected by the desiredAccuracy
 or distanceFilter properties. Returns location if user's is moved significantly, through DbLocationManagerDidUpdateLocation delegate call. Gives the significant location change continiously until the -stopGettingLocation is called
 *  <p>
 *  Apps can expect a notification as soon as the device moves 500 meters or more from its previous notification. It should not expect notifications more frequently than once every 5 minutes. If the device is able to retrieve data from the network, the location manager is much more likely to deliver notifications in a timely manner. (from Apple Doc)
 *  </p>
 */
-(void)getSignificantLocationChangeWithDelegate:(id)delegate;


/**
 *   Stops updating location for Continious or Significant changes
 *   <p>
 *   Use this method to stop accessing and getting the location data continiously. If you've called -getContiniousLocationWithDelegate: or -getSingificantLocationChangeWithDelegate: method before, call -stopGettingLocation method to stop that.
 *   </p>
 */
-(void)stopGettingLocation;

/**
 *   Adds a geofence at the current location
 *   <p>
 *   First updates current location of the device, and then add it as a Geofence. Optionally also tries to determine the Geocode/Address. Default radios of the fence is set to 100 meters
 *   </p>
 *   <p>
 *   Checks if there is already a fence exists in this coordinate, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, reverse geocoding method may fail for too many request in small amount of time.
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */
- (void)addGeofenceAtCurrentLocation;

/**
 *   Adds a geofence at the current location with a radious
 *   <p>
 *   First updates current location of the device, and then add it as a Geofence. Optionally also tries to determine the Geocode/Address. Also sets the radious of the fence with given value
 *   </p>
 *   <p>
 *   Checks if there is already a fence exists in this coordinate, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, reverse geocoding method may fail for too many request in small amount of time.
 *   @param radious: The radious for the fence
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */
- (void)addGeofenceAtCurrentLocationWithRadious:(CLLocationDistance)radious;

/**
 *   Adds a geofence at given latitude/longitude, radious and indentifer.
 *   <p>
 *   Checks if there is already a fence exists in this coordinate, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, always deliver Identifier value, otherwise the reverse geocoding method may fail for too many request in small amount of time.
 *   @param latitude: The latitude where to add the fence
 *   @param longitude: The longitude where to add the fence
 *   @param radious: The radious for the fence
 *   @param identifier: The name of the fence. If the indentifier is nil, this method will try to use geocode to determine the address of this coordinate and use it as identifer. WARNING: When using this method for adding multiple fence at once, always deliver Identifier value
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */

- (void)addGeofenceAtlatitude:(double)latitude andLongitude:(double)longitude withRadious:(double)radious withIdentifier:(NSString*)identifier;


/**
 *   Adds a geofence at given latitude/longitude, radious and indentifer.
 *   <p>
 *   Checks if there is already a fence exists in this coordinate, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, always deliver Identifier value, otherwise the reverse geocoding method may fail for too many request in small amount of time.
 *   @param latitude: The latitude where to add the fence
 *   @param longitude: The longitude where to add the fence
 *   @param radious: The radious for the fence
 *   @param identifier: The name of the fence. If the indentifier is nil, this method will try to use geocode to determine the address of this coordinate and use it as identifer. WARNING: When using this method for adding multiple fence at once, always deliver Identifier value
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */
- (void)addGeofenceAtCurrentLocationWithRadious:(CLLocationDistance)radious withIdentifier:(NSString*)identifier;

/**
 *   Adds a geofence at given coordinate, radious and indentifer.
 *   <p>
 *   Checks if there is already a fence exists in this coordinate, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, always deliver Identifier value, otherwise the reverse geocoding method may fail for too many request in small amount of time.
 *   @param coordinate: The coordinate as CLLocationCoordinate2D where to add the fence
 *   @param radious: The radious for the fence
 *   @param identifier: The name of the fence. If the indentifier is nil, this method will try to use geocode to determine the address of this coordinate and use it as identifer. WARNING: When using this method for adding multiple fence at once, always deliver Identifier value
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */
- (void)addGeofenceAtCoordinates:(CLLocationCoordinate2D)coordinate withRadious:(CLLocationDistance)radious withIdentifier:(NSString*)identifier;

/**
 *   Adds a geofence at given location, radious and indentifer.
 *   <p>
 *   Checks if there is already a fence exists in this location, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, always deliver Identifier value, otherwise the reverse geocoding method may fail for too many request in small amount of time.
 *   @param location: The location where to add the fence
 *   @param radious: The radious for the fence
 *   @param identifier: The name of the fence. If the indentifier is nil, this method will try to use geocode to determine the address of this coordinate and use it as identifer. WARNING: When using this method for adding multiple fence at once, always deliver Identifier value
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */
- (void)addGeofenceAtLocation:(CLLocation*)location withRadious:(CLLocationDistance)radious withIdentifier:(NSString*)identifier;

/**
 *   Adds a geofence at a location, radious and indentifer using the FenceInfo object
 *   <p>
 *   Checks if there is already a fence exists in this location, if so, fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeRepeated event.
 *   </p>
 *   @warning When using this method for adding multiple fence at once, always deliver Identifier value, otherwise the reverse geocoding method may fail for too many request in small amount of time.
 *   @param fenceInfo: The location where to add the fence
 *   @return fires delegate DbLocationManagerDidAddFence: with a DbFenceEventTypeAdded event.
 */

-(void)addGeoFenceUsingFenceInfo:(DbFenceInfo*)fenceInfo;


/**
 *   Deletes a geofence at a location, using the FenceInfo object
 *   <p>
 *   It searches for the  identifiers of the added fences based on fenceInfo, and deletes the desired one.
 *   </p>
 *   @param fenceInfo: The location where to add the fence
 */

-(void)deleteGeoFence:(DbFenceInfo*)fenceInfo;

/**
 *   Deletes a geofence with a identifier
 *   <p>
 *   It searches for the  identifiers of the added fences, and deletes the desired one.
 *   </p>
 *   @param identifier: The identifier of the geofence need to be deleted
 */
-(void)deleteGeoFenceWithIdentifier:(NSString*)identifier;

@end

