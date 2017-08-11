//
//  GamesViewController.h
//  DropDownDigitalAirports
//
//  Created by Bertle on 8/8/17.
//  Copyright © 2017 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <GameKit/GameKit.h>

@interface GamesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
