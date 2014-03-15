//
//  BSUpdateDBHandler.m
//  EuroApp
//
//  Created by Christian Gottitsch on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSUpdateDBHandler.h"
#import "InternetConnectionHandler.h"

@implementation BSUpdateDBHandler

@synthesize successNotification, errorNotification, strUrl;

-(id)init{
    
    if (self = [super init]) {
        
        internetConHandler = [[InternetConnectionHandler alloc] init];
        successNotification = nil;
        errorNotification = nil;
        strUrl = nil;
        
    }
    
    return self;
}

-(void)dealloc{
    [internetConHandler release];
    [strUrl release];
    [strPath release];
    [successNotification release];
    [errorNotification release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//
// 
//
//////////////////////////////////////////////////////////////////////////////////////////////
-(void)notificationString:(NSString*)notification {
    errorNotification = [NSString stringWithFormat:@"error%@", notification];
    successNotification = [NSString stringWithFormat:@"success%@", notification];
}
  
//////////////////////////////////////////////////////////////////////////////////////////////
//
// 
//
//////////////////////////////////////////////////////////////////////////////////////////////
-(void)startUpdateProcess{
    [self requestFileWithUrl];
}


-(void)downloadDBVersionFile{

}

-(void)requestFileWithUrl{
    
    if ([internetConHandler isConnectedToInternet]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorDownloading:) name:@"errorDownloading" object:internetConHandler];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successDownloading:) name:@"successDownloading" object:internetConHandler];
        
        // set members 
        [internetConHandler setNotificationStrings:@"Downloading"];
        NSString *downloadUrl = [NSString stringWithFormat:@"%@%@", RESTSERVICE_PATH, strUrl]; // TODO: CHANGE BACK!!
      //  NSString *downloadUrl = [NSString stringWithFormat:@"%@%@", @"http://www.bitschmiede.at/skialpin/restService2.php?", strUrl];
        
        NSLog(@"downloadUrl: %@",  downloadUrl);

        NSLog(@" destinationPath: %@",  strPath);
        internetConHandler.destFilename = strPath;
        //[internetConHandler setDestinationFilename:strPath];
        [internetConHandler setRequestURL:downloadUrl];
        [internetConHandler downloadFileFromUrl:nil];
    }else {
          [[NSNotificationCenter defaultCenter] postNotificationName:errorNotification object:self];
    }
    
    
    
}

//////////////////////////////////////////////////////////////////////////////////////////////
//
// 
//
//////////////////////////////////////////////////////////////////////////////////////////////
-(void)setDownloadUrl:(NSString*)url{
    strUrl = url;
}

-(void)createDestinationPathWithDirectoryName:(NSString*)dirName andFileName:(NSString*)fileName{
    
    NSString *dir;
    NSString *testDir;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
   
    //float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
    NSLog(@"cachePath: %@", cachePath);
    testDir =  [NSString stringWithFormat:@"%@/%@", cachePath, dirName];
    NSLog(@"testDir: %@", testDir);
    dir = [NSString stringWithFormat:@"/%@/%@/", cachePath, dirName];
    //strPath = [dir stringByAppendingFormat:fileName];
    strPath = [NSString stringWithFormat:@"/%@%@", dir, fileName];
}


//////////////////////////////////////////////////////////////////////////////////////////////
//
// 
//
//////////////////////////////////////////////////////////////////////////////////////////////
-(void)successDownloading:(NSNotification *)notification{
    NSLog(@"succhessDownloading");
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"successDownloadingStandingsFile" object:self];
    
    NSLog(@"successNotification: %@", successNotification);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:successNotification object:self];

}

-(void)errorDownloading:(NSNotification *)notification{
    NSLog(@"errorDownloading");
     [[NSNotificationCenter defaultCenter] postNotificationName:errorNotification object:self];

}


-(void)errorDownloadingNewDB:(NSNotification *)notification{
    
}

-(void)errorLoadingDBVersionFile:(NSNotification *)notification{

}

-(void)successLoadingDBVersionFile:(NSNotification *)notification{
    
}

-(void)successDownloadingNewDB:(NSNotification *)notification{
}



@end
