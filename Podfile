# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# Uncomment the next line if you're using Swift or would like to use dynamic frameworks
use_frameworks!

inhibit_all_warnings! # this will disable all the warnings for all pods

target 'SwiftApp' do

    # Libraries system Swift 4
    pod 'Alamofire', '4.7.3'
    pod 'MBProgressHUD', '1.1.0'
    #pod 'SVPullToRefresh', '0.4.1' # Cu khong su dung
    #pod 'DZNEmptyDataSet', '1.8.1' # Cu khong su dung
    
    pod 'IQKeyboardManagerSwift', '6.2.0'
    pod 'SnapKit', '4.0.1' # Phien ban Swift 4 cua Masonry : http://snapkit.io/docs/
    
    pod 'GoogleMaps'
    pod 'GooglePlaces'

    # Bo 4 di chung voi nhau
#    pod 'ObjectMapper', '3.3.0'
    #pod 'RealmSwift', '3.11.0'
    # https://github.com/jakenberg/ObjectMapper-Realm
#    pod 'ObjectMapper+Realm', '0.6'
#    pod 'EasyRealm', '3.4.0'
    
    # Bo 3 di chung voi nhau

    pod 'RealmSwift', '3.17.1' # Support Xcode 11
    # https://github.com/jakenberg/ObjectMapper-Realm
    pod 'ObjectMapper', '3.3.0' # Da bao gom SwiftyJSON (4.0.0)
    pod 'ObjectMapper+Realm', '0.6'
    pod 'EasyRealm', '3.4.0' # Realm support library
    
    pod 'ObjectMapperAdditions/Core', '4.2.1'
    pod 'ObjectMapperAdditions/Realm', '4.2.1'
    
    # Objective-C
    pod 'MMDrawerController', '0.6.0'

    # Integrate SwifterSwift extensions only (Alway update new version), current version '4.3.0'
    #pod 'SwifterSwift' # khong su dung duoc, ko bit tai sao 21/06/2018
#    pod 'SwifterSwift/SwiftStdlib'
#    pod 'SwifterSwift/Foundation'
#    pod 'SwifterSwift/AppKit'
#    pod 'SwifterSwift/CoreGraphics'

    # pod 'LGButton', tot manh nhung chi cho ios > 9.0

    # SwiftMessages => hien thi message tren bar, can dung thang nay cho he thong luon
    pod 'SwiftMessages', '6.0.0'
    pod 'SwiftLocation', '3.2.3' # Dung thang nay de quan ly location
    pod 'SwiftyJSON', '4.0.0'

    # Libraries needed Objective C
    # pod 'APNumberPad', '1.2.2' # Use for DecimalTextField
    # pod 'INTULocationManager', '4.3.2'
    pod 'FSCalendar', '2.8.0'
    #pod 'ActionSheetPicker-3.0' #, '2.3.0'

    # Libraries needed Swift 4
    pod 'DKImagePickerController', '4.1.3', :subspecs => ['PhotoGallery', 'Camera', 'InlineCamera']
    pod 'CropViewController', '2.4.0' # Swift version of TOCropViewController
    
    pod 'RevealingSplashView', '0.6.0'
    
    #pod 'StackScrollView', '1.2.0'
    #pod 'EasyPeasy', '1.7.0'
    #pod 'ClusterKit', '0.4.0'
    pod 'ClusterKit/MapKit'
    
    # => updated 10/01/2019, Eureka chay khong on dinh trong cac phien ban < ios 11
    pod 'Eureka', '4.3.1'
    # Eureka extensions : https://github.com/EurekaCommunity
    # FloatLabelRow => bi trung file DecimalFormatter voi Eureka, phai delete no trong pod
    pod 'FloatLabelRow', :git => 'https://github.com/larsacus/FloatLabelRow', :branch => 'ExposeColorProperties' # Version : 1.0.0
    # pod 'ViewRow', :git => 'https://github.com/EurekaCommunity/ViewRow' # Version : 0.3.0
    # Da tich hop ViewRow vao trong source du an PropzySam
    
    # Deu khong xu dung duoc khi dung xcode 10.2.1 Swift 5
    # pod 'TableRow', '0.3.1' # Khong phu hop
    # pod 'SuggestionRow', '2.2.0' # Khong phu hop
    
    # Dung thang nay de hien thi tips cho guide user, va hien thi Tips aciton
    pod 'EasyTipView', '2.0.4'
    

  # Pods for SwiftApp

  target 'SwiftAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
