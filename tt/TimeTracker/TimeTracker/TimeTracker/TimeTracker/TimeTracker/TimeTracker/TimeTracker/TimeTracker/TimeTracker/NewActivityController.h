//
//  NewActivityController.h
//  TimeTracker
//
//  Created by jay gulati on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITWCommon.h"
#import "sqlite3.h"
#import "Activity.h"

@interface NewActivityController : UIViewController{
    IBOutlet UITextField *activityName;
    IBOutlet UISlider *effort;
    IBOutlet UISlider *fulfillment;
    IBOutlet UISlider *necessity;
    IBOutlet UILabel *effortLabel;
    IBOutlet UILabel *fulfillmentLabel;
    IBOutlet UILabel *necessityLabel;
    Activity *activity;
    
}
@property (nonatomic, retain) IBOutlet UISlider *effort;
@property (nonatomic, retain) IBOutlet UISlider *fulfillment;
@property (nonatomic, retain) IBOutlet UISlider *necessity;
-(void)saveActivityInDatabase:(Activity *)_activity;
- (IBAction)effortChanged:(id)sender;
- (IBAction)fulfillmentChanged:(id)sender;
- (IBAction)necessityChanged:(id)sender;

@end
