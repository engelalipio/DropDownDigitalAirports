//
//  HPCMapViewController.m
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 2/7/15.
//  Copyright (c) 2015 agile.mobile.solutions. All rights reserved.
//

#import "MapViewController.h"
#import "UIView+Additions.h"
#import "AppDelegate.h"
@interface MapViewController (){
 double imageScale;
    AppDelegate *appDelegate;
    
}
@end

@implementation MapViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    
    if ([appDelegate airportCode]){
       /* if ([appDelegate.airportCode isEqualToString:@"LAS"]){
            [self.imageMap setImage:[UIImage imageNamed:@"MIA_Parking.jpg"]];
        }*/
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    
    self.btnMenu  = self.splitViewController.displayModeButtonItem;
    [self.navigationItem setLeftBarButtonItem:self.btnMenu];
 
    //[self loadSafari];
    [self loadWebView];
    return;
    
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


#pragma -mark Web View Methods

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSString *errMessage = @"";
    BOOL     isHidden = NO;
    
    @try{
        [self.imageMap setAlpha:0.30f];
        
    }
    @catch(NSException *exception){
        errMessage = [exception description];
    }
    @finally{
        if ([errMessage length] > 0){
            NSLog(@"%@",errMessage);
        }
        errMessage = @"";
        isHidden = NO;
    }
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    BOOL result   = NO,
         isHidden = NO;
    
    NSString *message= @"";
    
    SFSafariViewController *safariVC = nil;
    
    @try {
        if (request != nil){
            if (navigationType == UIWebViewNavigationTypeLinkClicked){
             
                safariVC = [[SFSafariViewController alloc] initWithURL:request.URL entersReaderIfAvailable:NO];
                
                if (safariVC){
                    [safariVC setDelegate:self];
                    [self presentViewController:safariVC animated:YES completion:nil];
                }
                
            }else{
                result = YES;
            }

            message = [NSString stringWithFormat:@"shouldStartLoadWithRequest for %@",request.URL.description];
        }
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length]> 0){
            NSLog(@"%@",message);
        }
        message = @"";
        isHidden = NO;
    }
    return  result;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *errMessage = @"";
    
    @try{
 
        [self.imageMap setAlpha:0.0f];
    }
    @catch(NSException *exception){
        errMessage = [exception description];
    }
    @finally{
        if ([errMessage length] > 0){
            NSLog(@"%@",errMessage);
        }
        errMessage = @"";
        
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSString *errMessage = @"";
    NSURLRequest *urlRequest = nil;
    @try{
        if (error){
            
            errMessage = [NSString stringWithFormat:@"Error Loading %@ in WebView with the following %@, trying again...",
                          [webView.request.URL description] ,
                          [error description]];
            
            urlRequest = [[NSURLRequest alloc] initWithURL:webView.request.URL];
            
            [self webView:webView shouldStartLoadWithRequest:urlRequest navigationType:UIWebViewNavigationTypeReload];
            
        }
    }
    @catch(NSException *exception){
        errMessage = [error description];
    }
    @finally{
        if ([errMessage length] > 0){
            NSLog(@"%@",errMessage);
        }
        errMessage = @"";
        urlRequest = nil;
    }
    
}

#pragma mark - Safari Delegate Method(s)

-(void) safariViewControllerDidFinish:(SFSafariViewController *)controller{
    NSLog(@"safariViewController:safariViewControllerDidFinish::Invoked");
    
}

-(void) safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    NSLog(@"safariViewController:didCompleteInitialLoad::Invoked");
}


-(void) loadWebView{
    
    NSString *vUrl = @"";
    
    NSURLRequest *request = nil;
    
    NSURL *url = nil;
    
    @try {
        
        vUrl = BWIMapURL;
        
        url = [NSURL URLWithString:vUrl];
        
        request = [[NSURLRequest alloc] initWithURL:url];
        
        if ([vUrl length] > 0){
            
            url  = [NSURL URLWithString:vUrl];
            
            [self.webView setDelegate:self];
            
            [self.webView loadRequest:request];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"loadWebViewError::->%@",exception.debugDescription);
    } @finally {
        vUrl = @"";
        request = nil;
    }
    
    
    
}

-(void) loadSafari{
    
    SFSafariViewController *safariVC = nil;
    NSString *message = @"";
    
    @try {
        
        message = [NSString stringWithFormat:@"loadSafari invoked for %@",BWIMapURL];
        NSLog(@"%@",message);
 
        safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:BWIMapURL] entersReaderIfAvailable:NO];
        
        if (safariVC){
            [safariVC setDelegate:self];
            [self presentViewController:safariVC animated:YES completion:nil];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    } @finally {
        safariVC = nil;
        message  = @"";
    }
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
    
    @try {
        
                [self doneAction:sender];
        return;
        
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
    } @catch (NSException *exception) {
        NSLog(@"Error-> %@",exception.description);
        [self doneAction:sender];
    } @finally {
        
    }

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
