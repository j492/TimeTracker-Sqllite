//
//  UserActivity.h
//  TimeTracker
//
//  Created by jay gulati on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActivity : NSObject
{
    NSInteger dataId;
    NSDate *activityDate;
    NSInteger activityId;
    NSDate *startDate;
    NSDate *endDate;
    NSString *activityName;
}
@property (nonatomic,retain) NSDate *activityDate;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,retain) NSDate *startDate;
@property (nonatomic,retain) NSDate *endDate;
@property (nonatomic,retain) NSString *activityName;

-(id)init:(NSDate *)aDate dataId:(NSInteger)id activityId:(NSInteger)aId startDate:(NSDate *)sDate endDate:(NSDate *)eDate activityName:(NSString *)activityName;

@end
