//
//  HPCMapViewController.m
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 2/7/15.
//  Copyright (c) 2015 agile.mobile.solutions. All rights reserved.
//

#import "MapViewController.h"
#import "UIView+Additions.h"

@interface MapViewController (){
double imageScale;
}
@end

@implementation MapViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
        
  /*  self.btnMenu  = self.splitViewController.displayModeButtonItem;
    [self.navigationItem setLeftBarButtonItem:self.btnMenu];*/
 
    [self.imageMap.layer setCornerRadius:5.0f];
    [self.imageMap.layer setMasksToBounds:YES];
    [self.imageMap setContentMode:UIViewContentModeScaleAspectFit];
    
    self.scrollView.minimumZoomScale=0.5;
    self.stpZoom.minimumValue = 0.5;
    self.stpZoom.maximumValue = 3.0;
    imageScale = self.stpZoom.value;
    self.scrollView.maximumZoomScale=3.0;
    self.scrollView.contentSize=CGSizeMake(self.imageMap.size.width, self.imageMap.size.height);
    [self.scrollView setDelegate:self];
}


#pragma mark -UISplitViewController


-(void) splitViewController:(UISplitViewController *)svc
          popoverController:(UIPopoverController *)pc
  willPresentViewController:(UIViewController *)aViewController{
    
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    
  //  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //self.masterPopoverController = nil;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageMap;
}


- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


- (IBAction)actionPrint:(UIBarButtonItem *)sender {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    
   [sharingItems addObject:self.imageMap.image];
    
 
    
    UIActivityViewController *activityController = nil;
    
    activityController = [[UIActivityViewController alloc]
                          initWithActivityItems:sharingItems
                           applicationActivities:nil];
    activityController.popoverPresentationController.barButtonItem = sender;

    [activityController setExcludedActivityTypes:@[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList,
                                                   UIActivityTypeCopyToPasteboard, UIActivityTypeMail,
                                                   UIActivityTypeMessage,UIActivityTypePostToFlickr,
                                                   UIActivityTypePostToTencentWeibo]];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)actionZoom:(UIStepper *)sender {
    
    double stepper = sender.value;
    
    if (stepper <= 0){
        stepper = 1;
    }
    if (imageScale <= 0){
        imageScale = 1;
    }
    
    if (stepper > imageScale){
        imageScale = imageScale + sender.stepValue;
    }else{
        imageScale = imageScale - sender.stepValue;
    }

    
    [self.scrollView setZoomScale:stepper animated:YES];
    [self.scrollView setFrame:[self zoomRectForScrollView:self.scrollView withScale:self.scrollView.zoomScale withCenter:self.scrollView.center]];
    
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
