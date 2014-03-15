//
//  InternetConnectionHandler.h
//  BLHistoric
//
//  Created by Christian Gottitsch on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface InternetConnectionHandler : NSObject {

    NSMutableData *fileData;
	NSURLConnection *connectionInProgress;
    
    NSString *url;
    NSString *destFilename;
    NSString *errorNotification;
    NSString *successNotification;
    
   }

+(BOOL)isConnectedToInternet;
-(BOOL)isConnectedToInternet;
- (void)downloadFileFromUrl:(NSString *)fileURL;
-(void)setNotificationStrings:(NSString*)notification;
//-(void) setDestinationFilename:(NSString*)filename;
-(void) setRequestURL:(NSString*) requestURL;
//-(void) downloadFileFromURL;
//-(bool) downloadFileFromURL:(NSString*)urlAsString ToPath:(NSString*)filename;
//-(BOOL) webFileExists;

-(void)successDownloading:(NSNotification *)notification;
-(void)errorDownloading:(NSNotification *)notification;

@property (nonatomic, retain)NSString *destFilename;

@end
