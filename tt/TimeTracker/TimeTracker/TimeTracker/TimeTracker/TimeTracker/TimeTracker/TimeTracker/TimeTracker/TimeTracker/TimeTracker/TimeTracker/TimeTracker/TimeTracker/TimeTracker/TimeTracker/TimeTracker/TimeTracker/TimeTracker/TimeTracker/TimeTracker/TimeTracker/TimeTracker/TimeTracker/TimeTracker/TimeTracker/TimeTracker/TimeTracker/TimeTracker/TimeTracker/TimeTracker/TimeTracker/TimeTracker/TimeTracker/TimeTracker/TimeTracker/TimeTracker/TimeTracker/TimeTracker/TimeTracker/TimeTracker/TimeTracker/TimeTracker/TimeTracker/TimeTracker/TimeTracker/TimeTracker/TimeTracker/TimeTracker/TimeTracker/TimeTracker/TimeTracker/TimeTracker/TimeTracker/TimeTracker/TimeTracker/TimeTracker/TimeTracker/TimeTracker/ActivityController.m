//
//  ActivityController.m
//  TimeTracker
//
//  Created by jay gulati on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityController.h"
#import "Activity.h"


@implementation ActivityController 

@synthesize activityDate, activityPicker, activities, activitiesDict;


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    NSLog(@"the selection is %@ at row %i", [activities objectAtIndex:row], row);
    NSLog(@"the selection is %@", [activitiesDict objectForKey:[activities objectAtIndex:row]]);
    NSLog(@"the activityid is %i", [[activitiesDict objectForKey:[activities objectAtIndex:row]] dataId]);
    uActivity.activityId = [[activitiesDict objectForKey:[activities objectAtIndex:row]] dataId];
    
}


- (IBAction)SaveActivity:(id)sender {
    uActivity.activityDate = activityDate;
    uActivity.startDate = (NSDate *)[startTime date];
    uActivity.endDate = (NSDate *)[endTime date];
    
    uActivity.activityId = [[activitiesDict objectForKey:[activities objectAtIndex:[activityPicker selectedRowInComponent:0]]] dataId];
   
    NSDateComponents* compstart = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:uActivity.startDate];
    
    NSInteger shour = [compstart hour];
    NSInteger sminute = [compstart minute];
    
    NSDateComponents* compend = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:uActivity.endDate];
    
    NSInteger ehour = [compend hour];
    NSInteger eminute = [compend minute];
    
    if (ehour < shour || (ehour == shour && eminute < sminute))
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [gregorian setTimeZone:zone];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        uActivity.endDate = [gregorian dateByAddingComponents:offsetComponents toDate:uActivity.endDate options:0];
    }
    
    if ([self validateUserActivityInDatabase:uActivity] ==FALSE)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your activity overlaps another activity." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:12];
        [alert show];
    }
    else
    {
        [self saveUserActivityInDatabase:uActivity];
        //show msg
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your activity is added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:12];
        [alert show];
    }
}

-(BOOL)validateUserActivityInDatabase:(UserActivity *)_activity {
	// Setup the database object
	sqlite3 *database;
    BOOL rtnValue;
    
    NSString *databasePath = [ITWCommon getDatabasePath];
	
    // Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		NSString *sql = [NSString stringWithFormat:@"select id from useractivity where startTime between %f and %f or endTime between %f and %f", [_activity.startDate timeIntervalSince1970], [_activity.endDate timeIntervalSince1970], [_activity.startDate timeIntervalSince1970], [_activity.endDate timeIntervalSince1970]]; 
        NSLog(@"%@",sql);
        const char *sqlStatement = [sql UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                rtnValue = FALSE;
			}
            else
            {
                rtnValue = TRUE;
            }
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    return rtnValue;

}

-(void)saveUserActivityInDatabase:(UserActivity *)_activity {
    
    // Copy the database if needed
    NSString *databasePath = [ITWCommon getDatabasePath];
    
    sqlite3 *database;
    
    if (uActivity.activityId == 0)
    {
        return;
    }
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        //NSString *temp = [NSString stringWithFormat:@"insert into allusers (user_id,user_name) VALUES (%@,%@)",user_id,user_name];
        const char *sqlStatement = "insert into userActivity (activityDate, activityId, startTime, endTime) VALUES (?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            sqlite3_bind_double(compiledStatement, 1, [_activity.activityDate timeIntervalSince1970]);
            sqlite3_bind_int( compiledStatement, 2, _activity.activityId);   
            sqlite3_bind_double(compiledStatement, 3,[_activity.startDate timeIntervalSince1970]);   
            sqlite3_bind_double(compiledStatement, 4,[_activity.endDate timeIntervalSince1970]);   
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Save Error: %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database); 
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [activities count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [activities objectAtIndex:row];
} 



-(void) readActivitiesFromDatabase {
	// Setup the database object
	sqlite3 *database;
    
	// Init the activity Array and dictionary
    activities = [[ NSMutableArray alloc] init];
    activitiesDict = [[ NSMutableDictionary alloc] init];
    

    NSString *databasePath = [ITWCommon getDatabasePath];
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from activity order by upper(name)";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSInteger id = sqlite3_column_int(compiledStatement, 0);
				NSInteger effort = sqlite3_column_int(compiledStatement, 2);
                NSInteger fulfillment = sqlite3_column_int(compiledStatement, 3);
                NSInteger necessity = sqlite3_column_int(compiledStatement, 4);
                
				// Create a new activity object with the data from the database
				Activity *activity = [[Activity alloc] init:aName dataId:id Effort:effort Fulfillment:fulfillment necessity:necessity owner:0];
                
				// Add the activity object to the activities Array for picker
				[activities addObject:aName];
                
                [activitiesDict setObject:activity forKey:aName];
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [self readActivitiesFromDatabase];
    //NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSInteger selectedRow =0;
    switch (hour) {
        case 7:
            selectedRow = [activities indexOfObject:@"Daily Hygiene"];
            break;
        case 8:
            selectedRow = [activities indexOfObject:@"Commute"];
            break;
        case 9:
        case 10:
            selectedRow = [activities indexOfObject:@"Work"];
            break;
        case 17:
        case 18:
            selectedRow = [activities indexOfObject:@"Commute"];
            break;
        case 20:
            selectedRow = [activities indexOfObject:@"Watch TV"];
            break;
        case 21:
            selectedRow = [activities indexOfObject:@"Internet Useful"];
            break;
        case 22:
            selectedRow = [activities indexOfObject:@"Sleep"];
            break;
        default:
            break;
    }
    
    [activityPicker selectRow:selectedRow inComponent:0 animated:YES];
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [scrollActivityView setScrollEnabled:YES];
    [scrollActivityView setContentSize:CGSizeMake(self.view.frame.size.width,1200)];
    [scrollActivityView setPagingEnabled:YES];
    [super viewDidLoad];
    //if (activities == nil || activities.count ==0)
    //{
    //    [self readActivitiesFromDatabase];
    //}
    uActivity = [UserActivity alloc];
    startTime.timeZone = [NSTimeZone localTimeZone];
    endTime.timeZone = [NSTimeZone localTimeZone];
    [startTime setDate:self.activityDate];
    [endTime setDate:self.activityDate];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
