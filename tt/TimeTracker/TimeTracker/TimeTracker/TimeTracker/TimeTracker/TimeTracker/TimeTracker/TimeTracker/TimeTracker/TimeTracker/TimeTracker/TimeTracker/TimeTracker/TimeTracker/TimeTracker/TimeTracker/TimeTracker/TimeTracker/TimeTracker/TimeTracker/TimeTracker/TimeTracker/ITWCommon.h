//
//  ITWCommon.h
//  TimeTracker
//
//  Created by jay gulati on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITWCommon : NSObject
+(NSString *)getDatabasePath;
+(NSDate *)dateWithOutTime:(NSDate *)inDate; 
@end
