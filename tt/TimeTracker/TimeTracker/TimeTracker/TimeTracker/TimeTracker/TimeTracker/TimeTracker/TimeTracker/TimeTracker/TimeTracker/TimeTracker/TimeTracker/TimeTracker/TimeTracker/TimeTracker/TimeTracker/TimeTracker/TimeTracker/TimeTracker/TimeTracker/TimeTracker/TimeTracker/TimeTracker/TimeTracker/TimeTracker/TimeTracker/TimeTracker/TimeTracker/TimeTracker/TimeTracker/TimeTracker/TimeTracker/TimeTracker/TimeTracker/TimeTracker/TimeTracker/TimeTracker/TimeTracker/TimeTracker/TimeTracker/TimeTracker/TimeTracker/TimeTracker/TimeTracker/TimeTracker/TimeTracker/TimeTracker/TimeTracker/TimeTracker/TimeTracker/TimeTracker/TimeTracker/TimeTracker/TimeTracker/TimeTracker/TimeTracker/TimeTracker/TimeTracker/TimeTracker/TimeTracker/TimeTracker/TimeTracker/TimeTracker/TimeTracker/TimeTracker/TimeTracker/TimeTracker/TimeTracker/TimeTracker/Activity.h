//
//  Activity.h
//  TimeTracker
//
//  Created by jay gulati on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
{
    NSInteger dataId;
    NSString *activityName;
    NSInteger effort;
    NSInteger fulfillment;
    NSInteger necessity;
    NSInteger owner;
}
@property (nonatomic,retain) NSString *activityName;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,assign) NSInteger effort;
@property (nonatomic, assign) NSInteger fulfillment;
@property (nonatomic,assign) NSInteger necessity;
@property (nonatomic,assign) NSInteger owner;

-(id)init:(NSString *)activityName dataId:(NSInteger)id Effort:(NSInteger)effort Fulfillment:(NSInteger)fulfillment necessity:(NSInteger)necessity owner:(NSInteger)owner;
@end
