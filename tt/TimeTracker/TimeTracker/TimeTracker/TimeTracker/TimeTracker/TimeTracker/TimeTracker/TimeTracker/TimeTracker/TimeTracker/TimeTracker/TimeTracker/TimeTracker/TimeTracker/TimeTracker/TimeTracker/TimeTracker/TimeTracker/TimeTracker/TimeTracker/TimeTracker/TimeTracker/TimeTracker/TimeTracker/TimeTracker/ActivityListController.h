//
//  ActivityListController.h
//  TimeTracker
//
//  Created by jay gulati on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "UserActivity.h"
#import "MyCell.h"
#import "ITWCommon.h"


@interface ActivityListController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *userActivities;
    UITableView *tableView;
    NSDate *selectedDate;
    int days;
}
@property (nonatomic, retain) NSMutableArray *userActivities;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic) int days;


-(void) readUserActivitiesFromDatabase;
-(void) deleteUserActivityFromDatabase:(NSInteger)dataId;
@end
