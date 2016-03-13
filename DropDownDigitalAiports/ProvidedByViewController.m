//
//  ProvidedByViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 7/11/15.
//  Copyright (c) 2015 Digital World International. All rights reserved.
//

#import "ProvidedByViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ProvidedByViewController ()
{
    NSString     *baseURL,
                        *embedHTML;
    
    AppDelegate *appDelegate;
}
-(void) initWebView;

@end

@implementation ProvidedByViewController


#pragma -mark Web View Methods

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSString *errMessage = @"";
    BOOL     isHidden = NO;
    
    @try{
        
        [self.providedImage setAlpha:0.30f];
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
    
    @try {
        if (request != nil){
            
            result = YES;
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
        [self.providedImage setAlpha:0.0f];
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


-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    
    NSInteger fontSize = kTitleSize;
    

    @try {
        
        if (appDelegate.isiPhone){
            fontSize = kTitleIPhoneSize;
            anyTitle = @"A Subsidiary Of Digital World International";
        }
        
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:@"Avenir Roman" size:fontSize]];
        [titleView setText:anyTitle];
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    return titleView;
}


#pragma -mark Utility Methods

-(void) initWebView{
    
    NSString *vUrl = baseURL;
    
    NSURLRequest *request = nil;
    
    NSURL *url = [NSURL URLWithString:vUrl];
    
    request = [[NSURLRequest alloc] initWithURL:url];
    
    if ([vUrl length] > 0){
        
        url  = [NSURL URLWithString:vUrl];
        
        [self.webView setDelegate:self];
        
        [self.webView loadRequest:request];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [AppDelegate currentDelegate];
    baseURL = @"http://www.dropdowndigitalmenus.com/Home/Contact";
    NSString *title = @"Menus Provided By DropDropDownDigitalMenus.Com\n A Subsidiary Of Digital World International";
    [self.navigationItem setTitleView:[self getSpecialTitleView:title]];
    [self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
