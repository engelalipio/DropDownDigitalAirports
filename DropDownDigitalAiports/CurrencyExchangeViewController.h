//
//  FirstViewController.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyExchangeViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *newsNav;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *newsImage;
@end

