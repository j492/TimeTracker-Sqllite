//
//  ActivityController.h
//  TimeTracker
//
//  Created by jay gulati on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "UserActivity.h"
#import "ITWCommon.h"

@interface ActivityController : UIViewController <UIPickerViewDelegate>
{
    NSDate *activityDate;
    UIPickerView *activityPicker;
    NSMutableDictionary *activitiesDict;
    NSMutableArray *activities;
    IBOutlet UIScrollView *scrollActivityView;
    IBOutlet UIDatePicker *startTime;
    IBOutlet UIDatePicker *endTime;
    UserActivity *uActivity;
}
@property (nonatomic, retain) NSDate *activityDate;
@property (nonatomic, retain)IBOutlet UIPickerView *activityPicker;
@property (nonatomic, retain) NSMutableArray *activities;
@property (nonatomic, retain) NSMutableDictionary *activitiesDict;

-(void)saveUserActivityInDatabase:(UserActivity *)_activity;
-(BOOL)validateUserActivityInDatabase:(UserActivity *)_activity;

@end
