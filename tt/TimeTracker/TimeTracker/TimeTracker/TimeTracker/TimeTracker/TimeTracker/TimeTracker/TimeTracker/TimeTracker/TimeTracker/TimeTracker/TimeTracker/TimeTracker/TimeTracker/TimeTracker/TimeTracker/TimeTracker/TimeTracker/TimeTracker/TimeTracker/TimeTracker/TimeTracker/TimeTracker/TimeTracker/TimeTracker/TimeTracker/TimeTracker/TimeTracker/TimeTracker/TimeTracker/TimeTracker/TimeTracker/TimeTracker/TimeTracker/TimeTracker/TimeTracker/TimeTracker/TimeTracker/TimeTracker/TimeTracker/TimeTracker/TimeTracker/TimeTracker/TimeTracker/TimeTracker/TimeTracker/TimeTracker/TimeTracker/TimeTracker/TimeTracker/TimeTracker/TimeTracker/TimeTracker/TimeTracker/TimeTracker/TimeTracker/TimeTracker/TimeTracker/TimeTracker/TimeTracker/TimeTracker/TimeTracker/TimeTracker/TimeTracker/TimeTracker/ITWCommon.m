//
//  ITWCommon.m
//  TimeTracker
//
//  Created by jay gulati on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ITWCommon.h"

@implementation ITWCommon

+(NSString *)getDatabasePath
{
    NSString *databaseName = @"ttdb.sqlite";
    
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}

+(NSDate *)dateWithOutTime:(NSDate *)inDate 
{
    if (inDate == nil ) {
        inDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:inDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


@end
