//
//  TTDal.m
//  TimeTracker
//
//  Created by jay gulati on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTDal.h"

@implementation TTDal


@synthesize dataId;
@synthesize activityName;
@synthesize effort;
@synthesize fulfillment;
@synthesize necessity;
@synthesize fileMgr;
@synthesize homeDir;

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ttdb.sqlite"]; 
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        //UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[tellErr show];
        
    }
    
}
-(void)GetAllActivities{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    //sqlite3 *db;
    NSString *sql = @"select name from activity";
    
    const char *select_stmt = [sql UTF8String];
    
    //Open db
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    
    sqlite3_open([cruddatabase UTF8String], &db);
    sqlite3_prepare_v2(db, select_stmt, -1, &stmt, NULL);
    

}

-(void)InsertRecords:(NSMutableString *) txt :(int) integer :(double) dbl{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    //sqlite3 *db;
    
    
    //insert
    //const char *sql = "Insert into data(coltext, colint, coldouble) ?,?,?";
    
    //Open db
    //NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    //sqlite3_open([cruddatabase UTF8String], &db);
    //sqlite3_prepare_v2(db, sql, 1, &stmt, NULL);
    //sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    //sqlite3_bind_int(stmt, 2, integer);
    //sqlite3_bind_double(stmt, 3, dbl);
    //sqlite3_step(stmt);
    //sqlite3_finalize(stmt);
    //sqlite3_close(db);   
    
    NSString *sql = [NSString stringWithFormat: @"INSERT INTO data(activity, effort, fulfillment, necessity) VALUES ('%@','%i','%i','%i')", activityName, effort, fulfillment, necessity];
    
    const char *insert_stmt = [sql UTF8String];
    
    //Open db
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    
    sqlite3_open([cruddatabase UTF8String], &db);
    
    sqlite3_prepare_v2(db, insert_stmt, -1, &stmt, NULL);
    

}

-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    //sqlite3 *db;
    
    
    //insert
    const char *sql = "Update data set coltext=? where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &db);
    sqlite3_prepare_v2(db, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [txt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(db);  
    
}
-(void)DeleteRecords:(NSString *)txt{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    //sqlite3 *db;
    
    //insert
    const char *sql = "Delete from data where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ttdb.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &db);
    sqlite3_prepare_v2(db, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(db);  
    
}


@end
