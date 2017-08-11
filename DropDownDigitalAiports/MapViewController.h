//
//  HPCMapViewController.h
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 2/7/15.
//  Copyright (c) 2015 agile.mobile.solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@import SafariServices;

@interface MapViewController : UIViewController<SFSafariViewControllerDelegate,UIWebViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnMenu;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnOrientation;
@property (strong, nonatomic) IBOutlet UIImageView *imageMap;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPrint;
@property (strong, nonatomic) IBOutlet UIStepper *stpZoom;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)actionPrint:(UIBarButtonItem *)sender;
- (IBAction)actionZoom:(UIStepper *)sender;
- (IBAction)doneAction:(UIBarButtonItem *)sender;

@end
