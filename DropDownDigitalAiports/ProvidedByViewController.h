//
//  ProvidedByViewController.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 7/11/15.
//  Copyright (c) 2015 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvidedByViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationItem *providedNav;
@property (strong, nonatomic) IBOutlet UIImageView *providedImage;



@end
