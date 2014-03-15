//
//  main.m
//  mapsdktest
//
//  Created by Administrator on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MQAnnotationSampleAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([MQAnnotationSampleAppDelegate class]));
    [pool release];
    return retVal;
}
