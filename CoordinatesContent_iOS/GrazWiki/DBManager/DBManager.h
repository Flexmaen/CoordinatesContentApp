//
//  DBManager.h
//  myLeague
//
//  Created by develop on 18.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface DBManager : NSObject {

    FMDatabase *db;
    NSMutableDictionary *returnDict;
    NSMutableArray *returnPlayerArray;
    int mRowsForTable;

}

@property(nonatomic, assign)int mRowsForTable;

-(NSMutableDictionary*)selectWorldcupStandingsNationsWithSelectString:(NSString*)selectString;
-(NSMutableDictionary*)selectCalendarDatesWithString:(NSString*)selectString;
-(void)openDatabase;
-(NSMutableDictionary*)selectRacerDetailsWithSelectString:(NSString*)selectString;
-(NSMutableDictionary*)selectWorldcupStandingsWithSelectString:(NSString*)selectString;
-(NSMutableDictionary*)selectRacersForSearchViewAndGetDict;
-(void)countItems:(NSString*)selectString;
-(NSString*)createEditableCopyOfDatabaseIfNeeded ;
/* directory to store data  > ios 5.0*/
- (NSString *)applicationCachesDirectory ;

@end
