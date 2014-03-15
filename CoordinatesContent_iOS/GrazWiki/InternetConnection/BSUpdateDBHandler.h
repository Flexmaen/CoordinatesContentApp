//
//  BSUpdateDBHandler.h
//  EuroApp
//
//  Created by Christian Gottitsch on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define RESTSERVICE_PATH @"http://www.server.url/communication/restService.php?"
//#define RESTSERVICE_PATH @"http://bitschmiede.no-ip.org/~thas/grazwiki/restService.php?"

//@"http://www.bitschmiede.at/skijump/restService.php?"

#import <UIKit/UIKit.h>

@class InternetConnectionHandler;

@interface BSUpdateDBHandler : NSObject{

    InternetConnectionHandler *internetConHandler;
    NSString *strUrl;
    NSString *strPath;
    
    NSString *successNotification;
    NSString *errorNotification;

}

@property(nonatomic, retain)NSString *successNotification;
@property(nonatomic, retain)NSString *errorNotification;
@property(nonatomic, retain)NSString *strUrl;

-(void)createDestinationPathWithDirectoryName:(NSString*)dirName andFileName:(NSString*)fileName;
-(void)setDownloadUrl:(NSString*)url;
-(void)startUpdateProcess;
-(void)downloadDBVersionFile;
//-(void)requestFileWithUrl:(NSString *)url;
-(void)requestFileWithUrl;
-(void)successDownloading:(NSNotification *)notification;
-(void)errorDownloading:(NSNotification *)notification;
-(void)notificationString:(NSString*)notification;

@end

