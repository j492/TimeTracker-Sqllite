//
//  ActivitySummary.h
//  TimeTracker
//
//  Created by jay gulati on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitySummary : NSObject

@property (nonatomic,retain) NSString *activityName;
@property (nonatomic, retain) NSString *hours;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic, assign) NSInteger id; //for delete

@end
