//
//  FileIOHandler.m
//  BLHistoric
//
//  Created by Christian Gottitsch on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileIOHandler.h"
#import "Utils.h"
#import "Definitions.h"

@implementation FileIOHandler


+ (NSString *)applicationCachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSLog(@"CachePath: %@", cachePath);
    return cachePath;
}

+(bool)compareDatabaseVersionStrings:(NSString*)dbVersion{
    
    bool isNewVersion = NO;
    // load the save data from plist
	NSString *filePath = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"dbversion.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   	if (![fileManager fileExistsAtPath: filePath]) {
        // no file to compare found!
        NSLog(@"no dbversion.plist file to compare found!");
    }else{
        // compare here 
        NSMutableDictionary *versionDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        int newDBVersion = [[versionDict objectForKey:@"dbVersion"] intValue];
        int oldDBVersion = [dbVersion intValue];
        if (newDBVersion > oldDBVersion){
            isNewVersion = YES;
        }
        [versionDict release];
    }
    return isNewVersion;
}

+(bool)isDatabaseLocked:(NSString*)dbVersion{
    
    bool isVersionLocked = NO;
    // load the save data from plist
	NSString *filePath = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"dbversion.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   	if (![fileManager fileExistsAtPath: filePath]) {
        // no file to compare found!
    }else{
        // compare here 
        NSMutableDictionary *versionDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if ([[versionDict objectForKey:@"dbVersion"] isEqualToString:@"0"]){
            isVersionLocked = YES;
        }
        [versionDict release];
    }
    return isVersionLocked;
}

+(NSString*)getNewDatabaseVersionFromFile{
    
    NSString *filePath = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"dbversion.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   	if (![fileManager fileExistsAtPath: filePath]) {
        // no file to compare found!
        return nil;
    }else{
        // compare here 
        NSMutableDictionary *versionDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSString *retVal;
        int nRetVal =  [[versionDict objectForKey:@"dbVersion"] intValue];
        retVal = [NSString stringWithFormat:@"%d", nRetVal];
        [versionDict release];
        return retVal; 
    }
    
}

+(bool)overwriteDatabaseWithNewOne:(bool)deleteNew{
    
    bool isCopyOK = NO;
    NSFileManager *filemgr;
    NSError *error;
    NSString *pathToZip;
    
    [FileIOHandler deleteOldDatabaseFromFileSystem];
    filemgr = [NSFileManager defaultManager];
    
    /*float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version > 5.0)
        pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"ski_alpin_online.sqlite"];
    //elseoka
     //   pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"/ski_alpin_online.sqlite/ski_alpin_online.sqlite"];*/

#ifdef SKI_ALPIN
    pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"/ski_alpin_online.sqlite/ski_alpin_online.sqlite"];
    // pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"ski_alpin_online.sqlite"];
#endif
    
#ifdef SKI_JUMPING
    //pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"ski_jump_online.sqlite"];
    pathToZip = [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:@"/ski_jump_online.sqlite/ski_jump_online.sqlite"];
#endif
    
      
    if ([filemgr moveItemAtPath: pathToZip toPath: [[FileIOHandler applicationCachesDirectory] stringByAppendingPathComponent:DATABASE_NAME] error: &error]  == YES){
        isCopyOK = YES;
       // [FileIOHandler deleteDownloadedDatabaseFromFileSystem];
    }
    else{
    
        NSLog(@"ERROR: %@", error);
        isCopyOK = NO;

    }
    
    return isCopyOK;
}

+(void)deleteDownloadedDatabaseFromFileSystem{
    NSString *databaseCachedirectory = [FileIOHandler applicationCachesDirectory];
    NSString *pathToDB; 
    
#ifdef SKI_ALPIN
    pathToDB = [databaseCachedirectory stringByAppendingPathComponent:@"ski_alpin_online.sqlite"];
#endif
    
#ifdef SKI_JUMPING
    pathToDB = [databaseCachedirectory stringByAppendingPathComponent:@"ski_jump_online.sqlite"];
#endif
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: pathToDB]) {
        [[NSFileManager defaultManager] removeItemAtPath:pathToDB error:NULL];
    }
}

+(void)deleteOldDatabaseFromFileSystem{
    NSString *databaseCachedirectory = [FileIOHandler applicationCachesDirectory];
    NSString *pathToDB = [databaseCachedirectory stringByAppendingPathComponent:DATABASE_NAME];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: pathToDB]) {
        [[NSFileManager defaultManager] removeItemAtPath:pathToDB error:NULL];
    }
}

@end
