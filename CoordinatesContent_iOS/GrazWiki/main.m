//
//  main.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 27.12.12.
//  Copyright (c) 2012 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "RMMapView.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [RMMapView class]; 
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
