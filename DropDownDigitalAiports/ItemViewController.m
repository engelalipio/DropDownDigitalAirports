//
//  ItemViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/9/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//
#import "Constants.h"
#import "ItemViewController.h"
#import "NumberFormatter.h"
#import "AppDelegate.h"
#import "DiningViewController.h"
#import "GroundTransportationViewController.h"
#import "itemModel.h"

@interface ItemViewController ()
{
    NSInteger rndImageUpperBounds;
    NSString *rndImageFormat;
    UIInterfaceOrientation currentOrientation;
    BOOL isFirstLaunch;
    AppDelegate *appDelegate;
}
-(void) configureView;

@end

@implementation ItemViewController

@synthesize foodType = _foodType;
@synthesize timer = _timer;
@synthesize loop = _loop;
@synthesize rndStatuses = _rndStatuses;
@synthesize rndImages = _rndImages;

+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    UIImage* newImage = nil;
    CGFloat scale = 0;
    NSString *message  = @"";
    @try {
        
         scale = [[UIScreen mainScreen]scale];
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
        [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
                             UIGraphicsEndImageContext();
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        message = @"";
    }

    return newImage;
}

+(NSString*)generateRandomPhone{
    
    NSString *message = @"",
                    *phoneFormat = @"(%@) %@-%@",
                    *phone     = @"",
                    *sCode = @"",
                    *sP = @"",
                    *sS = @"";
    
    NSInteger areaCode = 0,
                      prefix = 1,
                      suffix = 0;
    
    NSArray *areaCodes = nil;
    @try {
 
        areaCodes = [[NSArray alloc ] initWithObjects:@"212" ,@"904",@"407",@"305",@"216",@"718", nil];
        
        areaCode = arc4random_uniform(areaCodes.count);
        
        prefix = arc4random_uniform(538) + 315;
        
        suffix = arc4random_uniform(9943) + 2;
        
        sCode = [NSString stringWithFormat:@"%@",[areaCodes objectAtIndex:areaCode]];
        
        sP = [NSString stringWithFormat:@"%d",prefix];
        
        sS = [NSString stringWithFormat:@"%d",suffix];
        
        if ([sCode length] < 3){
            sCode = [sCode stringByAppendingString:@"0"];
        }
        
        if ([sP length] <3 ){
            sP = [sP stringByAppendingString:@"0"];
        }
        
        if ([sS length] > 4){
            sS = [sS stringByAppendingString:@"0"];
        }
        
        phone =[NSString stringWithFormat:phoneFormat,sCode,sP,sS];
        
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        areaCode = 0;
        prefix = 0;
        suffix = 0;
        phoneFormat = @"";
    }
    return phone;
}

-(void) configureView{
 
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [self.imageView setFrame:imageRect];

}


- (void)timerFireMethod:(NSTimer *)t{
    
    NSString *message                     = @"",
                    *rndFoodImgFormat  =  rndImageFormat,
                    *rndFoodImgName    = @"",
                    *rndStatus                   = @"",
                    *rndStatusImgName   = @"";
    
    UIImage  *image           = nil;
    
    NSInteger rndFoodImgId        = 0,
    imageUBId             = rndImageUpperBounds,
    rndMessageId        = 0;
    @try {
        
        
        if (self.rndStatuses && self.rndImages && self.rndLabel && self.rndImage){
            rndMessageId = arc4random_uniform(self.rndStatuses.count);
            rndStatus = [self.rndStatuses objectAtIndex:rndMessageId];
            rndStatusImgName = [self.rndImages objectAtIndex:rndMessageId];
            
            if (rndStatus && [UIImage imageNamed:rndStatusImgName]){
                [self.rndLabel setText:rndStatus];
                [self.rndImage setImage:[UIImage imageNamed:rndStatusImgName]];
            }
        }
        
       /* if (rndFoodImgId == 0){
            rndFoodImgId = 1;
        }*/
        
        while (! image) {
             rndFoodImgId = arc4random_uniform(imageUBId);
             rndFoodImgName = [ NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId];
             image = [UIImage imageNamed:rndFoodImgName ];
        }
    
        [self.AirlineIMGView setImage:image];
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        rndFoodImgId = 0;
        rndFoodImgFormat = @"";
        image = nil;
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
    }
    
}

- (void)timerStatusMethod:(NSTimer *)t{
    
    NSString *message                     = @"",
                    *rndStatus                   = @"",
                    *rndStatusImgName   = @"";
    
    NSInteger rndFoodImgId        = 0,
                      imageUBId             = rndImageUpperBounds,
                      rndMessageId        = 0;
    @try {
        
         rndFoodImgId = arc4random_uniform(imageUBId);
        
        if (self.rndStatuses && self.rndImages && self.rndLabel && self.rndImage){
            rndMessageId = arc4random_uniform(self.rndStatuses.count);
            rndStatus = [self.rndStatuses objectAtIndex:rndMessageId];
            rndStatusImgName = [self.rndImages objectAtIndex:rndMessageId];
            
            if (rndStatus && [UIImage imageNamed:rndStatusImgName]){
                [self.rndLabel setText:rndStatus];
                [self.rndImage setImage:[UIImage imageNamed:rndStatusImgName]];
            }
        }
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
    }
    
}

-(void) startRandomStatus :(NSArray  *) anyStatuses : (NSArray*) anyStatuImages : (UILabel*) anyLabel : (UIImageView*) anyImageView{
    
    double interval = [appDelegate interval];
    
    self.rndStatuses  =anyStatuses;
    self.rndImages = anyStatuImages;
    self.rndLabel  = anyLabel;
    self.rndImage = anyImageView;
    
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]]
                                          interval:interval target:self
                                          selector:@selector(timerStatusMethod:)
                                          userInfo:nil
                                           repeats:YES];
    
    self.loop = [NSRunLoop currentRunLoop];
    [self.loop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

-(void) startTimer :(NSString  *) anyImageFormat : (NSInteger) imagesUpperBound{
    
    double interval = [appDelegate interval];
    rndImageUpperBounds = imagesUpperBound;
    rndImageFormat = anyImageFormat;

    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]]
                                          interval:interval target:self
                                          selector:@selector(timerFireMethod:)
                                          userInfo:nil
                                           repeats:YES];
    
    self.loop = [NSRunLoop currentRunLoop];
    [self.loop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
}

-(void)stopTimer{
    if (self.timer != nil){
        [self.timer invalidate];
    }
    NSLog(@"Stopped timer for Item View Controller");
    self.timer = nil;
}

-(void) configureSegs{
    
    return;
   }

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.backButton.layer setCornerRadius:4.0f];
    [self.closeButton.layer setCornerRadius:4.0f];
    
 
        appDelegate = [AppDelegate currentDelegate];

    
    UIInterfaceOrientation anyOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self setupViewForOrientation:anyOrientation];
    // Do any additional setup after loading the view from its nib.

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelOrder:(UIButton *)sender {
    [self stopTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIInterfaceOrientation anyOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (! isFirstLaunch ){
        [self setupViewForOrientation:anyOrientation];
        isFirstLaunch = YES;
    }else{
        if (anyOrientation != currentOrientation){
            [self setupViewForOrientation:anyOrientation];
        }
    }
    
}

-(void) configureImageAndBorderView{
    
    if  (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        CGRect imageRect = CGRectMake(0, 53,1024, 312),
        borderRect = CGRectMake(0, 53,1024, 317);
        [self.imageView setFrame:imageRect];
        [self.imageBorderLabel setFrame:borderRect];
        
    }
}

-(void) setupViewForOrientation:(UIInterfaceOrientation) anyOrientation{
    
    NSString *message = @"";
   
    @try {
        
        switch (anyOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                message = kItemViewLandscape;
                break;
            default:
                //Portrait
                message = kItemViewPortrait;
                if (appDelegate.isiPhone){
                    message = kItemViewiPhonePortrait;
                }
                break;
        }
        
        
        self.view = [[NSBundle mainBundle] loadNibNamed:message owner:self options:nil][0];

        currentOrientation = anyOrientation;
        
 
        
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

- (BOOL) shouldAutorotate{
    //return no to prevent mid rotation change at this modal
    return NO;
}

@end
