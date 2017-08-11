//
//  LoginViewController.m
//  DropDownDigitalAirports
//
//  Created by Bertle on 8/4/17.
//  Copyright © 2017 Digital World International. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController (){
    AppDelegate *appDelegate;
    MSClient *azureClient;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Login



-(void) loginAction:(NSString *) anyProvider{
    NSURL *url = nil;
    
    @try {
        
        url = [[NSURL alloc] initWithString:kAirportConcierge];
        
        azureClient = [[MSClient alloc] initWithApplicationURL:url];
        
        if (azureClient){
            
            [azureClient loginWithProvider:anyProvider
                                 urlScheme:@"ddda"
                                controller:self
                                  animated:YES completion:^(MSUser * _Nullable user, NSError * _Nullable error) {
                                      
                                      if (error){
                                          NSLog(@"Error-> %@",error.description);
                                      }
                                      
                                      if (user){
                                          
                                      }
                                      
                                      
                                  }];
            
            
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"loginAndGetData:->%@",exception.debugDescription);
    } @finally {
        
        url =nil;
    }

}

- (IBAction)facebookLoginAction:(UIButton *)sender {
    
    
    [self loginAction:kFaceBook];
}

- (IBAction)twitterLoginAction:(UIButton *)sender {
    [self loginAction:kTwitter];
    
}
@end
