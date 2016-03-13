//
//  LimosViewController.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 7/18/15.
//  Copyright (c) 2015 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface LimosViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
