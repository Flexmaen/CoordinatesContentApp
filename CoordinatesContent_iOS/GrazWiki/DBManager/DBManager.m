//
//  DBManager.m
//  myLeague
//
//  Created by develop on 18.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Definitions.h"



@implementation DBManager

@synthesize mRowsForTable;

-(id)init{
   
    if (self = [super init]) {
        returnDict = [[NSMutableDictionary alloc] init];
        returnPlayerArray = [[NSMutableArray alloc] init];
      
        mRowsForTable = 0;
    }
    
    return self;
}


-(void)openDatabase{
    mRowsForTable = 0;
    if (returnDict == nil){
       // returnDict = [[NSMutableDictionary alloc] init];
    }    
    
    db = [FMDatabase databaseWithPath:[self createEditableCopyOfDatabaseIfNeeded]];
    if (![db open]) {
        return;
    }
    
    //  db = [FMDatabase databaseWithPath:[self dbPath]];
   // NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isThreadSafe] ? @"Yes" : @"No");
    
    {
		// -------------------------------------------------------------------------------
		// Un-opened database check.		
        //	FMDBQuickCheck([db executeQuery:@"select * from table"] == nil);
		NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}    
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    
    [db setShouldCacheStatements:YES];
    db.logsErrors = YES;
    db.crashOnErrors = NO;
    

}

-(void)closeDatabase{
    [db close];
}

/*
-(NSMutableDictionary*)selectWorldcupStandingsNationsWithSelectString:(NSString*)selectString{
    
    [returnDict removeAllObjects];
    // [self countSelectedItems];
    // [self countSelectedItems]; // write the number of teams to mRowsForTable
    
    if (db == nil){
        NSLog(@"@selectWorldcupStandingsNationsWithSelectString: db == nil");
    }
    
    [self openDatabase];
    
    if (selectString == nil)
        return nil;
    
    NSLog(@"DBManager - selectWorldcupStandingsNationsWithSelectString: %@", selectString);
    
    if (db == nil){
        NSLog(@"db is nil");
    }
    
    if ([db open]){
        NSLog(@"open!!!");
    }
    
    //selectString = @"SELECT * FROM public_historic_matchteams WHERE link = 'bundesliga-1963-1964-hamburger-sv-eintracht-frankfurt/'";
    
    FMResultSet *s = [db executeQuery:selectString];
    
    
    if (s == nil){
        NSLog(@"isNIL");
    }
    
    NSLog(@"DBManager - selectWorldcupStandingsNationsWithSelectString: %@", selectString);
    
    // returnDict = [[NSMutableDictionary alloc] init ];
    mRowsForTable = 0;
    while ([s next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init ];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"nation"]] forKey:@"nation"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"points"]] forKey:@"points"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank"]] forKey:@"rank"];    
        [returnDict setObject:tDict forKey:[NSString stringWithFormat:@"%d", mRowsForTable]];
        [tDict release];
        mRowsForTable++;
    }
    
    [s close];
    [db close];
    db = nil;
    
    //NSLog(@"selectWorldcupStandingsNationsWithSelectString - returnDict: %@", returnDict);
    
    return returnDict;
    
}

-(NSMutableDictionary*)selectWorldcupStandingsWithSelectString:(NSString*)selectString{
    
    if (returnDict == nil){
        NSLog(@"dict == nil");
    }else if ([returnDict count] == 0){
        NSLog(@"dict == 0");
    }
    
    [returnDict removeAllObjects];
    // [self countSelectedItems];
    // [self countSelectedItems]; // write the number of teams to mRowsForTable
    
    if (db == nil){
        NSLog(@"@selectWorldcupStandingsWithSelectString: db == nil");
    }
    
    [self openDatabase];
    
    if (selectString == nil)
        return nil;
    
    if (db == nil){
        NSLog(@"db is nil");
    }
    
    if ([db open]){
        NSLog(@"open!!!");
    }
    
    //selectString = @"SELECT * FROM public_historic_matchteams WHERE link = 'bundesliga-1963-1964-hamburger-sv-eintracht-frankfurt/'";
    
    FMResultSet *s = [db executeQuery:selectString];
    
    
    if (s == nil){
        NSLog(@"isNIL");
    }
    
    NSLog(@"DBManager - selectWorldcupStandingsWithSelectString: %@", selectString);
    
    // returnDict = [[NSMutableDictionary alloc] init ];
    mRowsForTable = 0;
    while ([s next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init ];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"year"]] forKey:@"year"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"discipline"]] forKey:@"discipline"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"fisid"]] forKey:@"fisid"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank"]] forKey:@"rank"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"points"]] forKey:@"points"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"sex"]] forKey:@"sex"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"name"]] forKey:@"name"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"nation"]] forKey:@"nation"];
        
              
        [returnDict setObject:tDict forKey:[NSString stringWithFormat:@"%d", mRowsForTable]];
        [tDict release];
        mRowsForTable++;
    }
    
    [s close];
    [db close];
    db = nil;
    
   //NSLog(@"selectWorldcupStandingsWithSelectString - returnDict: %@", returnDict);
    
    return returnDict;
    
}

-(NSMutableDictionary*)selectRacerDetailsWithSelectString:(NSString*)selectString{
    
    [returnDict removeAllObjects];
    // [self countSelectedItems];
    // [self countSelectedItems]; // write the number of teams to mRowsForTable
    
    if (db == nil){
        NSLog(@"@selectWorldcupStandingsWithSelectString: db == nil");
    }
    
    [self openDatabase];
    
    if (selectString == nil)
        return nil;
    
    NSLog(@"DBManager - selectWorldcupStandingsWithSelectString: %@", selectString);
    
    if (db == nil){
        NSLog(@"db is nil");
    }
    
    if ([db open]){
        NSLog(@"open!!!");
    }
    
    //selectString = @"SELECT * FROM public_historic_matchteams WHERE link = 'bundesliga-1963-1964-hamburger-sv-eintracht-frankfurt/'";
    
    FMResultSet *s = [db executeQuery:selectString];
    
    
    if (s == nil){
        NSLog(@"isNIL");
    }
    
    //NSLog(@"DBManager - selectWorldcupStandingsWithSelectString: %@", selectString);
    
    // returnDict = [[NSMutableDictionary alloc] init ];
    mRowsForTable = 0;
    while ([s next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init ];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"fisid"]] forKey:@"fisid"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"name"]] forKey:@"name"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"bdate"]] forKey:@"bdate"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"nation"]] forKey:@"nation"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"sex"]] forKey:@"sex"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"status"]] forKey:@"status"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wc_starts"]] forKey:@"wc_starts"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wc_podiums"]] forKey:@"wc_podiums"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wc_victories"]] forKey:@"wc_victories"];
        
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"ol_starts"]] forKey:@"ol_starts"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"ol_gold"]] forKey:@"ol_gold"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"ol_silver"]] forKey:@"ol_silver"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"ol_bronze"]] forKey:@"ol_bronze"];
        
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wm_starts"]] forKey:@"wm_starts"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wm_gold"]] forKey:@"wm_gold"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wm_silver"]] forKey:@"wm_silver"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"wm_bronze"]] forKey:@"wm_bronze"];

        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank_wc_podium"]] forKey:@"rank_wc_podium"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank_wc_victories"]] forKey:@"rank_wc_victories"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank_wc_starts"]] forKey:@"rank_wc_starts"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank_wc_winrate"]] forKey:@"rank_wc_winrate"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"rank_wc_podiumrate"]] forKey:@"rank_wc_podiumrate"];

        [returnDict setObject:tDict forKey:[NSString stringWithFormat:@"%d", mRowsForTable]];
        [tDict release];
        mRowsForTable++;
    }
    
    [s close];
    [db close];
    db = nil;
    
    //NSLog(@"selectRacerDetailsWithSelectString - returnDict: %@", returnDict);
    
    return returnDict;
    
}

-(NSMutableDictionary*)selectCalendarDatesWithString:(NSString*)selectString{
    
    [returnDict removeAllObjects];
    // [self countSelectedItems];
    // [self countSelectedItems]; // write the number of teams to mRowsForTable
    
    if (db == nil){
        NSLog(@"@selectCalendarDatesWithString: db == nil");
    }
    
    [self openDatabase];
    
    if (selectString == nil)
        return nil;
    
    NSLog(@"DBManager - selectCalendarDatesWithString: %@", selectString);
    
    if (db == nil){
        NSLog(@"db is nil");
    }
    
    if ([db open]){
        NSLog(@"open!!!");
    }
    
    //selectString = @"SELECT * FROM public_historic_matchteams WHERE link = 'bundesliga-1963-1964-hamburger-sv-eintracht-frankfurt/'";
    
    FMResultSet *s = [db executeQuery:selectString];
    
    
    if (s == nil){
        NSLog(@"isNIL");
    }

    
    // returnDict = [[NSMutableDictionary alloc] init ];
    mRowsForTable = 0;
    while ([s next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init ];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"eventid"]] forKey:@"eventid"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"location"]] forKey:@"location"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"date"]] forKey:@"date"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"nation"]] forKey:@"nation"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"discipline"]] forKey:@"discipline"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"sex"]] forKey:@"sex"];
        [returnDict setObject:tDict forKey:[NSString stringWithFormat:@"%d", mRowsForTable]];
        [tDict release];
        mRowsForTable++;
    }
    
    [s close];
    [db close];
    db = nil;
    
    //NSLog(@"selectCalendarDatesWithString - returnDict: %@", returnDict);
    
    return returnDict;
    
}



-(NSMutableDictionary*)selectRacersForSearchViewAndGetDict{
    
    [returnDict removeAllObjects];
    // [self countSelectedItems];
    // [self countSelectedItems]; // write the number of teams to mRowsForTable
    
    if (db == nil){
        NSLog(@"@selectPlayersForSearchViewAndGetDict: db == nil");
    }
    
    [self openDatabase];
   
    if (db == nil){
        NSLog(@"db is nil");
    }
    
    if ([db open]){
        NSLog(@"open!!!");
    }

    NSString *selectString;
#ifdef SKI_ALPIN
    selectString =  @"SELECT fisid, name,sex,nation FROM athletes";
#else
    selectString =  @"SELECT fisid, name,sex,nation FROM athletes where sex != 'N'";
#endif
    
    FMResultSet *s = [db executeQuery:selectString];

    if (s == nil){
        NSLog(@"isNIL");
    }
    
   // NSLog(@"DBManager - selectPlayerDetailsWithString: %@", selectString);
    
    // returnDict = [[NSMutableDictionary alloc] init ];
    mRowsForTable = 0;
    while ([s next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init ];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"name"]] forKey:@"name"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"sex"]] forKey:@"sex"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"fisid"]] forKey:@"fisid"];
        [tDict setObject:[NSString stringWithFormat:@"%@", [s stringForColumn:@"nation"]] forKey:@"nation"];
        [returnDict setObject:tDict forKey:[NSString stringWithFormat:@"%d", mRowsForTable]];
        [tDict release];
        mRowsForTable++;
    }
    
    [s close];
    [db close];
    db = nil;
    
   // NSLog(@"selectRacersForSearchViewAndGetDict: %@", returnDict);
    
    return returnDict;
    
}


-(void)countItems:(NSString*)selectString{
    
    [self openDatabase];
    mRowsForTable = 0;
    if ([db open]){
       // NSString *tSelectString = [NSString stringWithFormat:@"SELECT COUNT (*) FROM public_historic_table WHERE Id = '%@01' order by Position", mCurrentSeasonShortString];
        FMResultSet *s = [db executeQuery:selectString]; //@"SELECT COUNT (*) FROM public_historic_table WHERE Id = '196301' order by Position"];
        
        while ([s next]) {
            mRowsForTable =  [s intForColumnIndex:0];
        }
        
        [s close];
    }
    [db close];
    db = nil; // just for sure, that object isn't existing anymore
}

 
 */
-(NSString*)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *databaseCachedirectory = [self applicationCachesDirectory];
    NSString *writableDBPath = [databaseCachedirectory stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return writableDBPath;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    return defaultDBPath;
}

/* directory to store data  > ios 5.0*/
- (NSString *)applicationCachesDirectory {
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


@end
