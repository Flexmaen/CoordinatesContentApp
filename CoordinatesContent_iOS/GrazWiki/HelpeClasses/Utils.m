//
//  Utils.m
//  SkiAlpin2013
//
//  Created by Christian Gottitsch on 14.10.12.
//  Copyright (c) 2012 Christian Gottitsch. All rights reserved.
//

#import "Utils.h"
//#import "Definitions.h"
//#import "Reachability.h"

@implementation Utils



+ (BOOL)isIpad
{
    bool isIpad = NO;
    NSString *deviceType = [UIDevice currentDevice].model;
   // NSLog(@"deviceType: %@", deviceType);
    if([[deviceType substringToIndex:4] isEqualToString:@"iPad"]){
      isIpad = YES;
    }
    
    return isIpad;
}

+ (BOOL)isIphone
{
    bool isIphone = NO;
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType length] < 6)
        return NO;
    
    NSLog(@"deviceType: %@", deviceType);
    if([[deviceType substringToIndex:6] isEqualToString:@"iPhone"]){
         isIphone = YES;
    }
    return isIphone;
}

+ (BOOL)isIphone5
{
    bool isIphone5 = NO;
    
    if ([Utils isIphone]){
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        double screenHeight = screenBounds.size.height;
        if (screenHeight > 480)
            isIphone5 = YES;
    }
    
    return isIphone5;
}


+ (BOOL)isGermanLanguage{
    bool isGermanLanguage = NO;
    
    NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0]; // en_US
    if ([[locale substringToIndex:2] isEqualToString:@"de"]){
        isGermanLanguage = YES;
    }
    
    return isGermanLanguage;
}

+(BOOL)isConnectedToInternet{
    
    /*Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable) return NO;
    else return YES;*/
}

+(void)writeAvailableFontsToLog{
    NSString *family, *font;
    for (family in [UIFont familyNames])
    {
        NSLog(@"\nFamily: %@", family);
        
        for (font in [UIFont fontNamesForFamilyName:family])
            NSLog(@"\tFont: %@\n", font);
    }
}






@end
