//
//  TTDal.h
//  TimeTracker
//
//  Created by jay gulati on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TTDal : NSObject{
    NSInteger dataId;
    NSString *activityName;
    NSInteger effort;
    NSInteger fulfillment;
    NSInteger necessity;
    NSFileManager *fileMgr;
    NSString *homeDir;
    sqlite3 *db;
    
}
@property (nonatomic,retain) NSString *activityName;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,assign) NSInteger effort;
@property (nonatomic, assign) NSInteger fulfillment;
@property (nonatomic,assign) NSInteger necessity;

@property (nonatomic,retain) NSFileManager *fileMgr;
@property (nonatomic,retain) NSString *homeDir;

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;

-(void)InsertRecords:(NSMutableString *)txt :(int) integer :(double) dbl;
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt;
-(void)DeleteRecords:(NSString *)txt;
-(void)GetAllActivities;



@end