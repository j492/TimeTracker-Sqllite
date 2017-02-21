//
//  ActivityMaintController.h
//  TimeTracker
//
//  Created by jay gulati on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityCell.h"
#import "Activity.h"
#import "ITWCommon.h"
#import "sqlite3.h"

@interface ActivityMaintController : UIViewController
 <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *userActivities;
    UITableView *tableView;
    NSDate *selectedDate;
    int days;
}
@property (nonatomic, retain) NSMutableArray *userActivities;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDate *selectedDate;


-(void) readActivitiesFromDatabase;
-(void) deleteActivityFromDatabase:(NSInteger)dataId;
@end
