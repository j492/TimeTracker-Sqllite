//
//  ActivityListController.m
//  TimeTracker
//
//  Created by jay gulati on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityListController.h"
#import "ActivitySummary.h"

@implementation ActivityListController
@synthesize userActivities, tableView, selectedDate, days; //userActivitiesDict 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userActivities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = nil;
    NSString *uid = @"aCell";
    cell = (MyCell *)[self.tableView dequeueReusableCellWithIdentifier:uid];
    
    ActivitySummary *ua = [self.userActivities objectAtIndex:[indexPath row]];
    
    if (!cell)
    {
        NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil];
        for (id currentObject in toplevelObjects)
        {
            if ([currentObject isKindOfClass:[MyCell class]])
            {
                cell = (MyCell *)currentObject;
                break;
            }
        }
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uid];
    }
    //cell.textLabel.text = [[userActivities objectAtIndex:indexPath.row] activityName];
    cell.activityName.text = ua.activityName;
    //NSLog(ua.score);
    if (ua.score >= 64)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"floweritw.png"]];
    }
    if (ua.score < 64 && ua.score >=27)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"cautionitw.png"]];
    }
    else if (ua.score < 27)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"thornitw.png"]];
    }
    NSLog(@"aa:%@",ua.activityName);
    NSLog(@"aa:%@",ua.hours);
    cell.hours.text = ua.hours;
    return cell;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    //load data
    [self readUserActivitiesFromDatabase];
}
- (IBAction)editButtonClick:(id)sender
{
    if (![self.tableView isEditing])
    {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"Cancel"];
    }
    else
    {
        [self.tableView endEditing:YES];
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"Edit"];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if(editingStyle == UITableViewCellEditingStyleDelete)
     {
         //UserActivity *u = [[UserActivity alloc] init];
         ActivitySummary *u = [self.userActivities objectAtIndex:indexPath.row];
         [self.userActivities removeObjectAtIndex:indexPath.row];
         [self deleteUserActivityFromDatabase:u.id];
         //[self.userActivities removeObjectAtIndex:indexPath.row];
         [self.tableView reloadData];
         
     }
 }

-(void) deleteUserActivityFromDatabase:(NSInteger)dataId
{

    NSString *databasePath = [ITWCommon getDatabasePath];
    
    sqlite3 *database;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = [[NSString stringWithFormat:@"delete from useractivity where id = %i", dataId] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    
        {
            sqlite3_step(compiledStatement);
        }
        else
        {
            NSLog(@"Delete Error for id:%i", dataId);
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    if (self.days > 1)
    {
        return @"      Activity                       Hours";
    }
    else
    { 
        return @"      Activity                       Start-End";
    }
}

-(void) readUserActivitiesFromDatabase {
	// Setup the database object
	sqlite3 *database;
    NSString *sql;
    
	// Init the activity Array and dictionary
    userActivities = [[ NSMutableArray alloc] init];
    //userActivitiesDict = [[ NSMutableDictionary alloc] init];
    
    if (self.days > 1)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    NSString *databasePath = [ITWCommon getDatabasePath];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [gregorian setTimeZone:zone];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1*(self.days<=0?1:self.days)];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:self.selectedDate options:0];
    NSLog(@"%@", self.selectedDate);
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        if (self.days > 1)
        {
            sql = [NSString stringWithFormat:@"select name, sum((endTime-startTime)) as secs, (6-a.effort)*necessity*fulfillment as crazyfactor from useractivity ua inner join activity a on ua.activityid = a.id where ua.activityDate between %f and %f  group by activityid order by crazyfactor desc", [nextDate timeIntervalSince1970], [self.selectedDate timeIntervalSince1970]];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select name, (endTime-startTime) as secs, (6-a.effort)*necessity*fulfillment as crazyfactor, ua.id, startTime, endTime from useractivity ua inner join activity a on ua.activityid = a.id where ua.activityDate between %f and %f  order by startTime, endTime", [nextDate timeIntervalSince1970], [self.selectedDate timeIntervalSince1970]];        
        }
        
        const char *sqlStatement = [sql UTF8String];
        //, [selectedDate timeIntervalSince1970]] UTF8String];
        NSLog(@"%@",[NSString stringWithUTF8String:sqlStatement]);
        NSLog(@"%@",self.selectedDate);
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                ActivitySummary *activitysum = [[ActivitySummary alloc] init];
				activitysum.activityName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                if (self.days > 1)
                {
                    int secs = sqlite3_column_double(compiledStatement, 1);
                    int forHours = secs / 3600;
                    int forMinutes = (secs % 3600) / 60;
                    activitysum.hours = [NSString stringWithFormat:@"%d", forHours];
                    activitysum.hours = [activitysum.hours stringByAppendingString:@":"];
                    activitysum.hours = [activitysum.hours stringByAppendingString:[NSString stringWithFormat:@"%02d", forMinutes]];
                }
                else
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; 
                    [formatter setDateFormat:@"HH:mm"]; 
                    activitysum.hours=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 4)]];
                    activitysum.hours = [activitysum.hours stringByAppendingFormat:@"-"];
                    activitysum.hours=[activitysum.hours stringByAppendingFormat:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 5)]]];
                }
				
                activitysum.score = sqlite3_column_double(compiledStatement, 2);
                if (self.days <=1)
                {
                    activitysum.id = sqlite3_column_double(compiledStatement, 3);
                }
				// Add the activity object to the activities Array for picker
                NSLog(@"%@",activitysum.hours);
				[self.userActivities addObject:activitysum];
                
                //[userActivitiesDict setObject:activity forKey:activity.activityName];
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
}

@end
