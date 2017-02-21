//
//  UserActivity.m
//  TimeTracker
//
//  Created by jay gulati on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserActivity.h"

@implementation UserActivity
@synthesize dataId, activityId,activityDate, startDate,endDate, activityName;

-(id)init:(NSDate *)aDate dataId:(NSInteger)id activityId:(NSInteger)aId startDate:(NSDate *)sDate endDate:(NSDate *)eDate activityName:(NSString *)aName;
{
    self.activityDate = aDate;
    self.dataId = id;
    self.startDate = sDate;
    self.activityId = aId;
    self.endDate = eDate;
    self.activityName = aName;
    return self;
}
@end
