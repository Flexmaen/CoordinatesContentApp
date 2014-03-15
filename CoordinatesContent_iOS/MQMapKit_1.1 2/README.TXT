# MapQuest IOS SDK

In this zip you'll find:

* MQMapKit.framework
* Docs
* README.TXT
* ReleaseNotes.txt

For reference on classes included in this SDK, please see Docs/index.html.

## Setting up your project

To use the MapQuest SDK in your own project, you will need to link in the MQMapKit framework, and make sure you're project includes all the frameworks MQMapKit requires. In Xcode 4, follow these directions:

1. Select the project in the file view pane
2. Select your target on the right
3. open the "Link binary with libraries" section
4. click the plus at the bottom
5. click the "Add Other" button on the bottom left of the popup pane.
6. Locate MQMapKit.framework on the filesystem and click the Open button

Continue adding the following frameworks with the plus button if you don't have them already linked in:

* AddressBook.framework
* libxml2.dylib
* CoreLocation.framework
* QuartzCore.framework
* SystemConfiguration.framework

In your build settings: Add `-ObjC` to the target's `Other Linker Flags`

## Using MQMapKit in your code

You will need to import the main MQMapKit header file:

    #import <MQMapKit/MQMapKit.h>

and then initialize an `MQMapView` like so:

    MQMapView *map;
    map = [[MQMapView alloc] initWithFrame:self.view.bounds];
    // You need to set the center coordinate so that you're starting somewhere useful
    [map setCenterCoordinate:CLLocationCoordinate2DMake(47.63856, -122.542877)];


## Using MapQuest Commercial Services (MapQuest map tiles and Geocoding)

To use MapQuest commercial services, you will need to add the following property to your application's info.plist file:

    MapQuest.Map.Key

Set the value of this property to your MapQuest key.

## System Requirements

* iPhone 3G or later (3GS recommended)
* iPad Gen 1 (Gen 2 recommended)
* Xcode 4 or later
* iOS 4.2x or later
