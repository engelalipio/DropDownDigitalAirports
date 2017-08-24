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

@synthesize feedbackController = _feedbackController;

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
            anyTitle = @"Passenger Survey";
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


- (void)respondentDidEndSurvey:(SMRespondent *)respondent error:(NSError *) error {
    if (respondent != nil) {
        SMQuestionResponse * questionResponse = respondent.questionResponses[0];
        NSString * questionID = questionResponse.questionID;
    }
    else {
        NSLog(@"%@", error.description);
    }
    
    [self.providedImage setImage:[UIImage imageNamed:@"BWIlogo.png"]];
    
    
    _feedbackController = nil;
    
    [self performSegueWithIdentifier:@"segUnload" sender:self];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    if (! _feedbackController){
        _feedbackController = [[SMFeedbackViewController alloc] initWithSurvey:SurveyKey ];
        [_feedbackController setDelegate:self];
        [_feedbackController presentFromViewController:self animated:YES completion:nil];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [AppDelegate currentDelegate];
    baseURL = @"http://dropdowndigitalmenuswp.azurewebsites.net/example-survey/"; //@"http://DigitalWorldInternational.Com/Home/Contact";
    NSString *title = @"App Created By Digital World International\n";
    [self.navigationItem setTitleView:[self getSpecialTitleView:title]];
    
    //[self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSString *message = @"";
    
    @try {
        message = @"Unwinding...";
    }
    @catch (NSException *exception) {
        message = exception.debugDescription;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"prepareForUnwind->%@",message);
        }
        message = @"";
    }
    
    
}

@end
