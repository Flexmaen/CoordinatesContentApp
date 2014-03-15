//
//  InternetConnectionHandler.m
//  BLHistoric
//
//  Created by Christian Gottitsch on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InternetConnectionHandler.h"
//#import "FileIOHandler.h"
#import "Reachability.h"

@implementation InternetConnectionHandler

@synthesize destFilename;


-(void)dealloc{
    [url release];
    [destFilename release];
    
    [fileData release];
	[connectionInProgress release];
    [errorNotification release];
    [successNotification release];
    
	[super dealloc];
}

-(void)setNotificationStrings:(NSString*)notification{
    
       
    errorNotification = [notification copy];
    successNotification = [notification copy];

}

-(void) setRequestURL:(NSString*) requestURL {
    url = requestURL;
}


/*-(void) setDestinationFilename:(NSString*)filename{
    NSLog(@"filename: %@", filename);
    //destFilename = [filename copy];
    destFilename = filename;
}*/

/*
-(BOOL) webFileExists { // only for small files, because file will be downloaded before test !!!! 
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"statusCode = %d", [response statusCode]);
    
    if ([response statusCode] == 404)
        return NO;
    else
        return YES;
}*/

-(BOOL)isConnectedToInternet{

    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable) return NO;
    else return YES;
}

+(BOOL)isConnectedToInternet{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable) return NO;
    else return YES;
}


//********************************************
//********************************************
//********** DOWNLOAD FILE FROM URL **********
//********************************************
//********************************************
- (void)downloadFileFromUrl:(NSString *)fileURL
{
    
	NSLog(@"Get file from URL starting: %@", url);
    
	//NSURL *url = [NSURL URLWithString:fileURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestReloadIgnoringCacheData
										 timeoutInterval:20];
    
    if (request == nil){
        NSLog(@"request == nil");
    }
    
	//Clear any existing connection if there is one
	if (connectionInProgress)
	{
		[connectionInProgress cancel];
		[connectionInProgress release];
	}
    
	[fileData release];
	fileData = [[NSMutableData alloc] init];
    
	connectionInProgress = [[NSURLConnection alloc] initWithRequest:request
														   delegate:self
												   startImmediately:YES];
}

//*************************************************
//*************************************************
//********** NEXT BLOCK OF DATA RECEIVED **********
//*************************************************
//*************************************************
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[fileData appendData:data];
}

//******************************************
//******************************************
//********** ALL OF DATA RECEIVED **********
//******************************************
//******************************************
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Got file from URL now saving to path: %@", destFilename);
    
	//CONVERT TEXT FILE TO STRING
	//NSString *SourceString = [[[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"Text file received. Contents = %@", s);
    
	//DISPLAY AN IMAGE FILE
	//[MyImageView setImage:[UIImage imageWithData:fileData]];
    //NSString *path = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:destFilename];
   // NSLog(@"Got file from URL now saving to path with filename: %@", path);
    [fileData writeToFile:destFilename atomically:YES];
    
    
	//RELEASE CONECTION
	if (connectionInProgress)
	{
		[connectionInProgress release];
		connectionInProgress = nil;
	}
    
    
    NSString *strNotification = [NSString stringWithFormat:@"success%@", successNotification];
    NSLog(@"strNotification: %@", strNotification);

   // [[NSNotificationCenter defaultCenter] postNotificationName:@"successDownloading" object:self];
     [[NSNotificationCenter defaultCenter] postNotificationName:strNotification object:self];
    
}

//***************************************
//***************************************
//********** CONNECTION FAILED **********
//***************************************
//***************************************
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connectionInProgress release];
	connectionInProgress = nil;
    
	[fileData release];
	fileData = nil;
    
	NSLog(@"Get file from URL failed");
    
     [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"error%@", successNotification] object:self];
}

-(void)successDownloading:(NSNotification *)notification{
    
}

-(void)errorDownloading:(NSNotification *)notification{
    
}

@end
