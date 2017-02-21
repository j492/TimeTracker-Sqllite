//
//  NewActivityController.m
//  TimeTracker
//
//  Created by jay gulati on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewActivityController.h"

@implementation NewActivityController
@synthesize effort, fulfillment, necessity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)AfterActivity:(id)sender {
    [activityName resignFirstResponder];
}
- (IBAction)saveActivity:(id)sender {
    if ([activityName.text length]>0)
    {
        NSInteger owner = 1;
        activity = [[Activity alloc] init:activityName.text dataId:0 Effort:[effort value] Fulfillment:[fulfillment value] necessity:[necessity value] owner:owner];
        [self saveActivityInDatabase:activity];
        
        //show msg
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Activity is added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:12];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter activity." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:12];
        [alert show];
    }
}

-(void)saveActivityInDatabase:(Activity *)_activity {
    
    // Copy the database if needed
    NSString *databasePath = [ITWCommon getDatabasePath];
    
    sqlite3 *database;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "insert into activity (name, effort, fulfillment, necessity,owner) VALUES (?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            sqlite3_bind_text(compiledStatement, 1, [_activity.activityName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int( compiledStatement, 2, _activity.effort);   
            sqlite3_bind_int(compiledStatement, 3,_activity.fulfillment);   
            sqlite3_bind_int(compiledStatement, 4,_activity.necessity);
            sqlite3_bind_int(compiledStatement, 5,1); //user is the owner of the activity.
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Save Error: %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database); 
}

- (IBAction)effortChanged:(id)sender {
    effortLabel.text = [NSString stringWithFormat:@"%d",(int)(effort.value)];
}

- (IBAction)fulfillmentChanged:(id)sender {
        fulfillmentLabel.text = [NSString stringWithFormat:@"%d",(int)(fulfillment.value)];
}

- (IBAction)necessityChanged:(id)sender {
        necessityLabel.text = [NSString stringWithFormat:@"%d",(int)(necessity.value)];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //[scrollView setScrollEnabled:YES];
    //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)];
    //[scrollView setPagingEnabled:YES];
    [super viewDidLoad];
    //UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //scroll.pagingEnabled = YES;
}


- (void)viewDidUnload
{
    fulfillmentLabel = nil;
    necessityLabel = nil;
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
