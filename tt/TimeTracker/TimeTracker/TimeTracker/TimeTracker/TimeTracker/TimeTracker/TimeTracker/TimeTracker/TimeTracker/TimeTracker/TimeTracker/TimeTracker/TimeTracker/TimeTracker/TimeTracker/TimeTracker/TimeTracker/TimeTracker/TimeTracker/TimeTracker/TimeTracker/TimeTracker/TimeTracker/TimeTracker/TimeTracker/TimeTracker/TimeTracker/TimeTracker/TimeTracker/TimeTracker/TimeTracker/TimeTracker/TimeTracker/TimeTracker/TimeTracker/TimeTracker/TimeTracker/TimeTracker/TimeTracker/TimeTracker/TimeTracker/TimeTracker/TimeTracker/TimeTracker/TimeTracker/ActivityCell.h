//
//  ActivityCell.h
//  TimeTracker
//
//  Created by jay gulati on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *activityName;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,retain) IBOutlet UILabel *effort;
@property (nonatomic, retain) IBOutlet UILabel *fulfillment;
@property (nonatomic,retain) IBOutlet UILabel *necessity;
@property (nonatomic, retain) IBOutlet UIImageView *activityImageView;
@end
