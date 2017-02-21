//
//  MyCell.h
//  TimeTracker
//
//  Created by jay gulati on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *activityName;
@property (nonatomic, retain) IBOutlet UILabel *hours;
@property (nonatomic, retain) IBOutlet UIImageView *activityImageView;

@end
