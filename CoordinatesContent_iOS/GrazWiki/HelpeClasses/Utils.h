//
//  Utils.h
//  SkiAlpin2013
//
//  Created by Christian Gottitsch on 14.10.12.
//  Copyright (c) 2012 Christian Gottitsch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject {

}


+ (BOOL)isIphone;
+ (BOOL)isIpad;
+ (BOOL)isGermanLanguage;
+ (BOOL)isIphone5;

+(BOOL)isConnectedToInternet;
+(void)writeAvailableFontsToLog;


@end
