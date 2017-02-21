//
//  ActivityMaintController.m
//  TimeTracker
//
//  Created by jay gulati on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityMaintController.h"

@implementation ActivityMaintController
@synthesize userActivities, tableView, selectedDate;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userActivities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = nil;
    NSString *uid = @"aCell";
    cell = (ActivityCell *)[self.tableView dequeueReusableCellWithIdentifier:uid];
    
    Activity *ua = [self.userActivities objectAtIndex:[indexPath row]];
    
    if (!cell)
    {
        NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil];
        for (id currentObject in toplevelObjects)
        {
            if ([currentObject isKindOfClass:[ActivityCell class]])
            {
                cell = (ActivityCell *)currentObject;
                break;
            }
        }
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uid];
    }
    cell.activityName.text = ua.activityName;
    cell.effort.text = [NSString stringWithFormat:@"%d", ua.effort];
    cell.fulfillment.text = [NSString stringWithFormat:@"%d",ua.fulfillment];
    cell.necessity.text = [NSString stringWithFormat:@"%d",ua.necessity];
    NSInteger score = (6-ua.effort)*ua.necessity*ua.fulfillment;
    if (score >= 64)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"floweritw.png"]];
    }
    if (score < 64 && score >=27)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"cautionitw.png"]];
    }
    else if (score < 27)
    {
        [cell.activityImageView setImage:[UIImage imageNamed:@"thornitw.png"]];
    }    return cell;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self readActivitiesFromDatabase];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //UserActivity *u = [[UserActivity alloc] init];
        Activity *u = [self.userActivities objectAtIndex:indexPath.row];
        [self.userActivities removeObjectAtIndex:indexPath.row];
        [self deleteActivityFromDatabase:u.dataId];
        //[self.userActivities removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
}

-(void) deleteActivityFromDatabase:(NSInteger)dataId
{
    
    NSString *databasePath = [ITWCommon getDatabasePath];
    
    sqlite3 *database;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = [[NSString stringWithFormat:@"delete from activity where id = %i", dataId] UTF8String];
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
    return @"      Activity                       E    F    N";
}

-(void) readActivitiesFromDatabase {
	// Setup the database object
	sqlite3 *database;
    NSString *sql;
    
	// Init the activity Array and dictionary
    userActivities = [[ NSMutableArray alloc] init];
    //userActivitiesDict = [[ NSMutableDictionary alloc] init];
    
    //if (self.days > 1)
    //{
    //    self.navigationItem.rightBarButtonItem = nil;
    //}
    
    NSString *databasePath = [ITWCommon getDatabasePath];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {

        sql = @"select name, effort, fulfillment, necessity, id from activity order by name";        
        
        const char *sqlStatement = [sql UTF8String];
        //, [selectedDate timeIntervalSince1970]] UTF8String];
        NSLog(@"%@",[NSString stringWithUTF8String:sqlStatement]);
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                Activity *activitysum = [[Activity alloc] init];
				activitysum.activityName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                activitysum.effort = sqlite3_column_double(compiledStatement, 1);
                activitysum.fulfillment = sqlite3_column_double(compiledStatement, 2);
                activitysum.necessity = sqlite3_column_double(compiledStatement, 3);
                activitysum.dataId = sqlite3_column_double(compiledStatement, 4);

  
				[self.userActivities addObject:activitysum];
                				
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
