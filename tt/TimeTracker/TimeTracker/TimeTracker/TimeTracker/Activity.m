//
//  Activity.m
//  TimeTracker
//
//  Created by jay gulati on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize dataId, activityName, effort, fulfillment, necessity, owner;

-(id)init:(NSString *)actName dataId:(NSInteger)id Effort:(NSInteger)e Fulfillment:(NSInteger)f necessity:(NSInteger)n owner:(NSInteger)o
{
    self.activityName = actName;
    self.dataId = id;
    self.effort = e;
    self.fulfillment = f;
    self.necessity = n;
    self.owner = o;
    return self;
}
@end
