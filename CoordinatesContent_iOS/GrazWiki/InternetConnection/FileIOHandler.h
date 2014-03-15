//
//  FileIOHandler.h
//  BLHistoric
//
//  Created by Christian Gottitsch on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileIOHandler : NSObject{
    

}

+ (NSString *) applicationCachesDirectory;
+ (NSString*) getNewDatabaseVersionFromFile;
+ (bool)compareDatabaseVersionStrings:(NSString*)dbVersion;
+ (bool)overwriteDatabaseWithNewOne:(bool)deleteNew;
+ (void)deleteDownloadedDatabaseFromFileSystem;
+ (void)deleteOldDatabaseFromFileSystem;
+(bool)isDatabaseLocked:(NSString*)dbVersion;

@end
