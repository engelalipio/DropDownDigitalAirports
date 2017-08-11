//
//  LoginViewController.h
//  DropDownDigitalAirports
//
//  Created by Bertle on 8/4/17.
//  Copyright © 2017 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnFaceBook;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;

- (IBAction)facebookLoginAction:(UIButton *)sender;
- (IBAction)twitterLoginAction:(UIButton *)sender;




@end
