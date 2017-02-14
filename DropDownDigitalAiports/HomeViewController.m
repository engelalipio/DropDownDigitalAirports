//
//  HomeViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/24/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "ContainerTableCellTableViewCell.h"
#import "PageContentViewController.h"
#import "UIColor+ColorWithHexString.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "ItemViewController.h"

@interface HomeViewController ()
{
    NSArray *categorySections,
                   *categoryHomeData,
                   *dining,
                   *flights,
                   *shops,
                   *terminals,
                   *lounges,
                   *hotels;
    
    UIInterfaceOrientation currentOrientation;
    PageContentViewController *currentContent;
    
    AppDelegate *appDelegate;
    BOOL isFirstLoaded;
}
-(void) initPreferredLanguage;
-(void) initMenuSettings;
-(void) initTableView;
-(void) initCategorySections;
-(void) roundCorner;

@end

@implementation HomeViewController

@synthesize pageTitles = _pageTitles;
@synthesize pageImages = _pageImages;
@synthesize currentPageIndex = _currentPageIndex;

#pragma mark - TableView Events

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSInteger size = 60;
    if (appDelegate.isiPhone){
        switch (appDelegate.screenHeight) {
            case 736:
                size = 50;
                break;
                
            default:
                size = 40;
                break;
        }
    }
    return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   // return CGFLOAT_MIN;
    NSInteger size = 60;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) || appDelegate.isiPhone){
        size = 1.0f;
    }
    return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger size = 60;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) || appDelegate.isiPhone){
        size = 1.0f;
    }
    return size;
}


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSInteger size = 60,
                     fontSize = 20;
    
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, size)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, size)];
    
    /*titleLabel.text = @"The Most Incredible Travel Experience";
      titleLabel.textColor = [UIColor orangeColor];
     */
    titleLabel.textColor = kVerticalTableBackgroundColor;
    if (appDelegate.isiPhone){
        fontSize = 13;
    }
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
}

/*
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIButton *footer = nil;
    
    UIImage *image = nil;
    NSString *message = @"";
    
    @try {
        
        image = [UIImage imageNamed:@"your_ad_here_banner.jpg"];
        footer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 60)];
        [footer setImage:image forState:UIControlStateNormal];
        [footer addTarget:self action:@selector(actionAdClicked:) forControlEvents:UIControlEventTouchUpInside];
        
       [self.btnAds setHidden:YES];
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    return footer;
}
*/

-(void) roundCorner{
//Add border and rounded corners to text view
self.addressLabel.layer.cornerRadius = 10;
self.addressLabel.layer.borderWidth = 1;
self.addressLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    
    
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            
            UIImage *cellImage = nil;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
             /*   if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(80, 40)];
                }
                [cell.imageView setFrame:CGRectMake(0, 0, 80, 40)];
                [cell.imageView setImage:cellImage];*/
             
                //This will set the background of all of the views within the tablecell
             //   [cell.contentView.superview setBackgroundColor:[UIColor colorWithPatternImage:cellImage]];
            //    [cell.textLabel setTextColor:[UIColor whiteColor]];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message = @"";
    }

}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *message   = @"",
                    *title     = @"",
                    *cellId    = @"",
                    *imageName = @"";
    
    UITableViewCell *cell = nil;
    
    BOOL isDynamic  = appDelegate.isDynamic,
                isParse      = NO;
    
    NSArray *images = nil;
    
    NSInteger fontSize = 25;
    
    @try {
        
        isDynamic = appDelegate.isDynamic;
        
       //@"Flights",@"Dining",@"Shopping",@"Lounges",@"Terminals",@"Hotels", nil];
        
        switch (indexPath.row) {
            case 0:
                cellId = @"cbFlightsCell";
                if (flights){
                    if (flights.count == 1){
                        if (appDelegate.flightbackgrounds){
                            flights = appDelegate.flightbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    images = flights;
                }

                break;
            case 1:
                cellId = @"cbDiningCell";
                if (dining){
                    
                    if (dining.count == 1){
                        if (appDelegate.diningbackgrounds){
                            dining = appDelegate.diningbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    
                    images = dining;
                }
                break;
            case 2:
                cellId = @"cbShopsCell";
                if (shops){
                    
                    if (shops.count == 1){
                        if (appDelegate.shopsbackgrounds){
                            shops = appDelegate.shopsbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    
                    images = shops;
                }
                break;
            case 3:
                
                cellId = @"cbHotelsCells";
                if (hotels){
                    
                    if (hotels.count == 1){
                        if (appDelegate.hotelbackgrounds){
                            hotels = appDelegate.hotelbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    
                    images = hotels;
                }
                
            break;
            case 4:

                
                cellId = @"cbTerminalsCell";
                if (terminals){
                    
                    if (terminals.count ==1){
                        if (appDelegate.groundbackgrounds){
                            terminals = appDelegate.groundbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    images = terminals;
                }
                break;
            case 5:

                
                cellId = @"cbLoungesCell";
                if (lounges){
                    
                    if (lounges.count ==1){
                        if (appDelegate.sightseeingbackgrounds){
                            lounges = appDelegate.sightseeingbackgrounds;
                            isParse = YES;
                        }
                    }else{
                        isParse = YES;
                    }
                    
                    images = lounges;
                }
                

                break;
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (! cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellId];
            
        }

        title = [categoryHomeData objectAtIndex:indexPath.row];
        
        NSInteger rndIndex = arc4random_uniform(images.count);
        
        if (isDynamic){

            UIImage *cellImage = nil;

            if (isParse) {
              
               // [Utilities setParseImageCell:images anyIndex:rndIndex tableCell:cell];
                cellImage =  [Utilities getAzureStorageImage:images anyIndex:rndIndex];
                cellImage = cell.imageView.image;
            }else{
                imageName = [images objectAtIndex:rndIndex];
                cellImage =  [UIImage imageNamed:imageName];
            }
            
            if (appDelegate.isiPhone){
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(100, 50)];
                }
            }

            [cell.imageView setImage:cellImage];
        
            
        }else{
            [cell.imageView setImage:nil];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        if (appDelegate.isiPhone){
            fontSize = 14.8f;
            [cell.textLabel setNumberOfLines:0];
            if (indexPath.row > 2){
                fontSize = 15.0f;
            }
            
        }
      
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:fontSize]];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setText:title];
        
    
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    
    rows = categoryHomeData.count;
    
    return rows;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = 1;
    
    if (categorySections){
        // sections = [categorySections count];
    }
    
    return sections;
}

#pragma mark - iAdBanner Events

-(void) bannerViewDidLoadAd:(ADBannerView *)banner{
    NSString *message = @"";
    @try {
        
                     message = @"bannerViewDidLoadAd:(ADBannerView *)banner";
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length]> 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

-(void) bannerViewActionDidFinish:(ADBannerView *)banner{
    NSString *message = @"";
    @try {
        
        message = @"bannerViewActionDidFinish:(ADBannerView *)banner";
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length]> 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSString *message = @"";
    @try {
        
        if (error){
            message = [error description];
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
    }
}

#pragma mark - Utility Methods

-(void) preparePageViewData{
    NSString *message = @"",
             *desc    = @"";
    
    PageContentViewController *initialContent = nil;
    NSArray *viewControllers  = nil,
            *restaurantImages = nil;
    
    UIPageControl *currentPageControl = nil;
    
    @try {
        
        if (! self.pageTitles){
            _pageTitles  = [[NSArray alloc] initWithObjects:@"", @"",@"", @"",@"",@"",@"",@"", nil];
            
            NSMutableDictionary *restaurantDetail =  [categorySections firstObject];
            
            if (restaurantDetail){
                desc = [restaurantDetail objectForKey:@"description"];
                
                if (appDelegate.isDynamic){
                    if (appDelegate.backgrounds){
                     restaurantImages = [[NSArray alloc] initWithArray:appDelegate.backgrounds];
                    }else{
                    restaurantImages = [[NSArray alloc]
                                        initWithObjects:@"AirportBack_0.jpg",@"AirportBack_2.jpg",@"AirportBack_3.jpg",
                                                        @"AirportBack_4.jpg", @"AirportBack_5.jpg", @"AirportBack_7.jpg",@"AirportBack_8.jpg",@"AirportBack_9.jpg",
                                                        @"AirportBack_0.jpg" ,@"AirportBack_10.jpg",nil];
                    }
                }
                else{
                    restaurantImages = [restaurantDetail objectForKey:@"items"];
                }
                
                if (restaurantImages){
                    NSMutableDictionary *finalImages = [[NSMutableDictionary alloc] initWithCapacity:restaurantImages.count];
                    for (int imgIndex = 0; imgIndex < restaurantImages.count; imgIndex++) {
                        
                        NSDictionary *imageRawName = [restaurantImages objectAtIndex:imgIndex];
                        
                        NSString     *imageKey     = [NSString stringWithFormat:@"%d",imgIndex];
                      
                        
                        if (imageRawName){
                            NSString *imageShortName = [imageRawName objectForKey:@"image"];
                           
                            [finalImages setValue:imageShortName forKey:imageKey];
                        }
                        
                    }
                    restaurantImages = [finalImages allValues];
                }
            }
        

            _pageImages  = [[NSArray alloc] initWithArray:restaurantImages];
            
            _currentPageIndex = 0;
            
            if (! self.pageControl){
                
                currentPageControl = [UIPageControl appearance];
                [currentPageControl setPageIndicatorTintColor:[UIColor grayColor] ];
                [currentPageControl setCurrentPageIndicatorTintColor:[UIColor lightGrayColor]];
                [currentPageControl setBackgroundColor:[UIColor clearColor]];
                [currentPageControl setNumberOfPages:_pageImages.count];
                
                _pageControl = currentPageControl;
            }
        }
        
        currentPageControl = self.pageControl;
        
        
      //  [self setDataSource:self];
        
        initialContent = [self viewControllerAtIndex:self.currentPageIndex];
        
        viewControllers = [[NSArray alloc] initWithObjects:initialContent, nil];
    
        
        /*[self setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];*/
        
        
        [currentPageControl setCurrentPage:_currentPageIndex];
        
        currentContent = initialContent;
        
        // Change the size of page view controller
        
       /* [self.view addSubview:initialContent.view];
        [self.view setFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                        self.view.frame.size.width, self.view.frame.size.height )];*/
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        initialContent = nil;
        viewControllers = nil;
        currentPageControl = nil;
    }
}


-(void) startTimer{
    
    [self preparePageViewData];
    
    double interval = [appDelegate interval];
    
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
    NSLog(@"Home View Timer stopped");
    self.timer = nil;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && self.timer){
        [self stopTimer];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Child Reported!"
                                                        message:@"Security Will Be Here Shortly." delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        if (alert){
            [alert show];
        }
        
    }
}

-(void) ResetMissingPerson{
    
    if (appDelegate.missingPersonImage){
      //  [appDelegate setMissingPersonImage:nil];
    }
    if (appDelegate.isMissingPerson){
      //  [appDelegate setIsMissingPerson:NO];
    }
    
    [self.imageView setContentMode:UIViewContentModeScaleToFill];
    
    if(!self.btnLight.isHidden){
        [self.btnLight setHidden:YES];
    }
    if (self.addressLabel.textColor == [UIColor redColor]){
        
        [self.addressLabel setText:appDelegate.restaurantName];
        [self.addressLabel setTextColor:[UIColor whiteColor]];
    }
    
    [self.imageView setBackgroundColor:[UIColor clearColor]];
    [self.imageView setImage:[UIImage imageNamed:@"AirportBack_0.jpg"]];
    
    [self startTimer];
}

- (IBAction)actionLight:(UIButton *)sender {
    
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Click ‘OK’ To Report Your Missing Child To Security"
                                       message:@"" delegate:self
                             cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    
    if (alert){
        [alert show];
    }
    
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


- (IBAction)actionAdClicked:(UIButton *)sender {
    return;
         NSString *message = @"";

    static float const  alphaAnimationDuration = kAnimationSpeed;
    
    CALayer *layerToAnimate = nil;
    
    CAKeyframeAnimation *itemViewAlphaAnimation = nil;
    
    CABasicAnimation    *itemAlphaFadeAnimation     = nil;
    
    CAAnimationGroup    *alphaAnimationGroup = nil;
    
    @try {
    
       layerToAnimate = sender.layer;
        
        itemViewAlphaAnimation = [[CAKeyframeAnimation alloc] init];
        [itemAlphaFadeAnimation setKeyPath:@"opacity"];
        
        itemAlphaFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];

        itemAlphaFadeAnimation.toValue = [NSNumber numberWithFloat:0.5];
        
        alphaAnimationGroup = [CAAnimationGroup animation];
        
        [alphaAnimationGroup setAnimations:[NSArray arrayWithObjects:itemAlphaFadeAnimation, nil]];
        
        [alphaAnimationGroup setRepeatCount:1];
        [alphaAnimationGroup setDuration:alphaAnimationDuration];
        [alphaAnimationGroup setDelegate:self];
        [alphaAnimationGroup setRemovedOnCompletion:YES];
        [alphaAnimationGroup setValue:@"alphaAnimationGroup" forKey:@"name"];
        
        [layerToAnimate addAnimation:alphaAnimationGroup forKey:nil];
        
      
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }

}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    ADBannerView *adFooter = nil;
 
    
    NSString *message =@"";
    @try {
        
        if (flag){
            
            message = [NSString stringWithFormat:@"Finished the %@ animation",anim.description];
            NSLog(@"%@",message);
 
  
                
                adFooter = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.btnAds.frame.size.width, self.btnAds.frame.size.height)];
                [adFooter setDelegate:self];
               [self.btnAds addSubview:adFooter];
              message = [NSString stringWithFormat:@"Sucessfully initialized [initWithAdType:ADAdTypeBanner]"];
            
        }
        
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        
        message = @"";
    }
    
}



- (void)timerFireMethod:(NSTimer *)t{
    
    NSString *message         = @"";
    NSArray  *images          = nil;
    UIImage  *image           = nil;
    NSIndexSet *indexSet      = nil;
    NSIndexPath *indexPath    = nil;
    NSInteger randomAnimation = 0,
                      randomSection   = 0,
                     pagesCount = 0;
    
    BOOL isMissingPerson = NO;
    
    PFObject *missingPerson = nil;
    
    PFFile *file  = nil;
    
    NSData *missingChildData = nil;
    
    UIImage *missingChildImage = nil;
    
    @try {
        
        
        if (appDelegate.connectionImageName){
            [self.imgConnection setImage:[UIImage imageNamed:appDelegate.connectionImageName]];
        }
      
        isMissingPerson = [appDelegate isMissingPerson];
        //Check on the server first
        
       /* if (! isMissingPerson){
            MSQuery *query = nil;//TODO-> Missing Person[PFQuery queryWithClassName:@"MissingPerson"];
        
        if (query){
            
           query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            NSArray *missingPeople =  (NSArray*) [query findObjects];
            
            if (missingPeople.count){
                
                missingPerson = (PFObject*) [missingPeople objectAtIndex:0];
                
                file = [missingPerson objectForKey:@"Image"];
                
                if (file){
                    
                    missingChildData =  [file getData];
                    
                    if (missingChildData){
                        missingChildImage = [UIImage imageWithData:missingChildData];
                        if (missingChildImage){
                            [appDelegate setMissingPersonImage:missingChildImage];
                            [appDelegate setIsMissingPerson:YES];
                        }
                    }
                    
                }
                
            }
            
        }
       }*/
        
        if (! isMissingPerson){
            
            if (! [self.btnLight isHidden]){
                [self  ResetMissingPerson];
            }
            pagesCount = arc4random_uniform(appDelegate.backgrounds.count);
            [Utilities setParseImageView:appDelegate.backgrounds anyIndex:pagesCount tableCell:self.imageView];
        }else{
            
            image = appDelegate.missingPersonImage;
            [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.btnLight setHidden:NO];
            [self.addressLabel setNumberOfLines:0];
            [self.addressLabel setText:@"Missing Child Alert!\nClick On The Informational Button On The Right To Notify Security!"];
            [self.addressLabel setTextColor:[UIColor redColor]];
            [self.imageView setBackgroundColor:[UIColor blackColor]];
            [self.imageView setImage:image];
        }
    
        _currentPageIndex = pagesCount;
    
        randomAnimation = arc4random_uniform(5);
        randomSection   = arc4random_uniform(6);
        
        indexPath = [NSIndexPath indexPathForRow:randomSection inSection:0];
        
        indexSet = [[NSIndexSet alloc] initWithIndex:randomSection];
        
        [self.tableView beginUpdates];
        
        images = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        [self.tableView reloadRowsAtIndexPaths:images withRowAnimation:randomAnimation];
    
        [self.tableView endUpdates];
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        
        missingChildData = nil;
        missingChildImage = nil;
        missingPerson = nil;
        
    }
    
    
}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    
    NSInteger size = 768,
                     fontSize = kTitleSize,
                     titleViewSize = 65.0f;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        size = 1024;
    }
    
    @try {
        
        if (appDelegate.isiPhone){
            fontSize = kTitleIPhoneSize;
        }
        
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, size, titleViewSize)];
        [titleView setBackgroundColor: [UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:kTitleColor];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        
        [titleView setFont:[UIFont fontWithName:kTitleFont size:fontSize]];
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

-(void) setImageNames:(NSArray *) sourceArray destData:(NSArray *) targetArray {
    
    NSString *message       = @"",
             *imageName = @"";
    
    NSMutableArray *imgNames  = nil;
    
    NSDictionary *background = nil;
    @try {
    
        if (sourceArray){
            
        imgNames = [[NSMutableArray alloc] initWithCapacity:sourceArray.count];
        
            for(int idx = 0; idx < sourceArray.count ; idx++){
                background = [sourceArray objectAtIndex:idx];
                if (background){
                    imageName = [background objectForKey:@"Name"];
                    if (imageName){
                        [imgNames addObject:imageName];
                    }
                }
            }
            targetArray = [[NSArray alloc] initWithArray:imgNames];
        }
        
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"setImageNames -> %@",message);
        }
        message = nil;
        imgNames = nil;
        background= nil;
        imageName = nil;
    }
    
}

-(void) initCategorySections{
    
    NSString *message = @"";
    
 
    @try{
        
        [self.navigationItem setTitleView:[self getSpecialTitleView:appDelegate.restaurantTable]];
        [self.addressLabel setText: appDelegate.restaurantName ];
        
        categoryHomeData = [[NSArray alloc] initWithObjects:@"Arriving/Departing Flights",@"Fine Dining/Meals To Go/The Food Court",
                                                                                                 @"Shopping/Concessions & Gift Stores",@"Nearby Hotels",
                                                                                                 @"Ground Transportation",@"SightSeeing Attractions", nil];
        
        if (appDelegate.isDynamic){
            
            self.pageTitles  = [[NSArray alloc] initWithObjects:@"AirportBack_0.jpg" ,nil];
            
            [self setImageNames:appDelegate.backgrounds destData:self.pageTitles];
            
        
            categorySections = @[ @{ @"description": appDelegate.restaurantName,
                                     @"items": @[ @{ @"image": @"AirportBack_0.jpg" }]
                                     } ];
        
            
            flights =  [[NSArray alloc] initWithObjects:@"AirportFlight_1.jpg" ,nil];
            
            [self setImageNames:appDelegate.flightbackgrounds destData:flights];
        
            dining = [[NSArray alloc] initWithObjects:@"AirportDining_0.jpg", nil];
            
            [self setImageNames:appDelegate.diningbackgrounds destData:dining];
            
            shops = [[NSArray alloc] initWithObjects:@"AirportShops_0.jpg",nil];
            
            [self setImageNames:appDelegate.shopsbackgrounds destData:shops];
            
            lounges  = [[NSArray alloc] initWithObjects:@"Location_0.jpg", nil];
            
            [self setImageNames:appDelegate.sightseeingbackgrounds destData:lounges];
            
            hotels = [[NSArray alloc] initWithObjects:@"AirportHotels_0.jpg",nil];
            
            [self setImageNames:appDelegate.hotelbackgrounds destData:hotels];
            
            terminals = [[NSArray alloc] initWithObjects:@"AirportLuggage_1.jpg", nil];
            
            [self setImageNames:appDelegate.groundbackgrounds destData:terminals];
            
        }else{
        
            categorySections = @[ @{ @"description": appDelegate.restaurantName,
                                     @"items": @[ @{ @"image": @"AirportBack_0.jpg" }]
                                     } ];
            
            self.pageTitles  = [[NSArray alloc] initWithObjects:@"AirportBack_0.jpg", nil];
            
            dining  = nil;
            flights    = nil;
            lounges = nil;
            shops   = nil;
            terminals  = nil;
            hotels = nil;
        }
        

        
    }
    @catch(NSException *error){
        message = [error description];
    }
    @finally{
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
    }
    
}

-(void) initTableView{
    
    NSString *message = @"";
    
    @try{
        
        if (! self.tableView){
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, kTableYStart, kTabletWidth, kTableHeight)];
        }
        
        self.tableView.backgroundColor =  kTableCellTitleColor;
        
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        
        
        
    }
    @catch(NSException *error){
        message = [error description];
    }
    @finally{
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
    }
    
}

#pragma -mark - PageContent Events


-(NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.pageTitles count];
}

-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return self.currentPageIndex;
}

-(PageContentViewController*) viewControllerAtIndex:(NSUInteger) anyIndex{
    
    NSString *message = @"",
                    *imageTitle = @"",
                    *imageName  = @"";
    
    PageContentViewController *pageContentViewController = nil;
    
    @try {
        
        if (([self.pageTitles count] == 0) || (anyIndex >= [self.pageTitles count])) {
            return nil;
        }
        
        // Create a new view controller and pass suitable data.
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPageContent"];
        
        imageTitle = [self.pageTitles objectAtIndex:anyIndex];
        imageName  = [self.pageImages objectAtIndex:anyIndex];
        
        if (pageContentViewController){
            [pageContentViewController setFrameRect:CGRectMake(0.0, 21.0, 768.0, 368.0)];
            [pageContentViewController setImageFile:imageName];
            [pageContentViewController setTitleText:imageTitle];
            [pageContentViewController setPageIndex:anyIndex];
            
           // message = [NSString stringWithFormat: @"Loading Page Content for %@", pageContentViewController.titleText];
        }
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        
        message = @"";
    }
    return pageContentViewController;
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSString *message = @"";
    NSUInteger index = -1;
    PageContentViewController *contentController = nil;
    @try {
        
        contentController = (PageContentViewController*) viewController;
        
        index =  contentController.pageIndex;
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil;
        }
        
        index--;
        
        contentController = [self viewControllerAtIndex:index];
    
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        index = -1;
    }
    return contentController;
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSString *message = @"";
    NSUInteger index = -1;
    PageContentViewController *contentController = nil;
    @try {
        
        
        contentController = (PageContentViewController*) viewController;
        
        index = contentController.pageIndex;
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index++;
        
        if (index >= [self.pageTitles count]){
            return nil;
        }
        
        contentController = [self viewControllerAtIndex:index];
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        index = -1;
    }
    return contentController;
}


-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    NSString *message = @"";
    @try {
        message = @"Invoked[pageViewController->didFinishAnimating]";
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

-(void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    NSString *message = @"";
    @try {
        message = @"Invoked[pageViewController->willTransitionToViewControllers]";
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

-(void) initPreferredLanguage{
    
    NSString *language = @"";
    
    language = [appDelegate language];
    
    [self.imageLanguage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[language uppercaseString]]]];
    
}

-(void) initMenuSettings{
    
    BOOL isDynamic = NO;
    NSString *welcomeMessage = @"%@ \n %@";
    
    isDynamic = [appDelegate isDynamic];
 
    [self initCategorySections];
    [self.tableView reloadData];
    
    if (isDynamic){
      [self startTimer];
    }
    
    /*welcomeMessage = [NSString stringWithFormat:welcomeMessage, appDelegate.restaurantName,
                      appDelegate.restaurantAddress, appDelegate.restaurantCity,appDelegate.restaurantState,
                      appDelegate.restaurantZip];*/
    
   // welcomeMessage = appDelegate.restaurantName;
    
    welcomeMessage = [NSString stringWithFormat:welcomeMessage,appDelegate.restaurantName, appDelegate.currentBuildInfo];
    
    [self.addressLabel setNumberOfLines:0];
    [self.addressLabel setText:welcomeMessage];
    
}


-(void) viewDidAppear:(BOOL)animated{
    NSString *message = @"";
    NSIndexPath *indexPath = nil;
    @try {

        [self initPreferredLanguage];
        [self initMenuSettings];
        
        indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath){
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
 

    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        indexPath = nil;
    }
    
   
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
    
    NSArray *btnAddSubViews = [self.btnAds subviews];
    
    if (btnAddSubViews){
        ADBannerView *banner = [btnAddSubViews lastObject];
    
        if (banner){
            if ([banner isKindOfClass:[ADBannerView class]]){
                [banner removeFromSuperview];
                NSLog(@"Removed Banner from btnAds");
            }
             banner = nil;
        }
 
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstLoaded  = NO;
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initCategorySections];
    //[self roundCorner];
    [self initTableView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    BOOL result = YES;
      NSString *segName = identifier;
     
     if (! [segName length] > 0){
     result = NO;
     }
    
    return result;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedIP = [self.tableView indexPathForSelectedRow];
    
    MenuViewController *destVC = (MenuViewController*) [segue destinationViewController];
    
    NSString *message = @"";
    
    @try {
        message = [NSString stringWithFormat:@"%@",destVC.description];
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    
}


-(void) viewDidLayoutSubviews{
    
 
     [self setupViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
 
}


-(void) setupViewForOrientation:(UIInterfaceOrientation) anyOrientation{
    
    NSString *message = @"";
    
    @try {
        
        switch (anyOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                message = kItemViewLandscape;
 
                    CGRect imageRect = CGRectMake(0.0f, 64.0f, 1024,250),
                                 tableRect = CGRectMake(0.0f, 255, 1024,500),
                                 addrRect = CGRectMake(0.0f, 64, 1024, 45),
                                boarderRect = CGRectMake(0.0f, 0, 1024, 505),
                                buttonRect = CGRectMake(0.0f, 676, 1024, 30);
                
                      [self.btnAds setFrame:buttonRect];
                    [self.imageView setFrame:imageRect];
                    [self.tableView setFrame:tableRect];
                    [self.addressLabel setFrame:addrRect];
             //       [self.imageBorderLabel setFrame:boarderRect];
                break;
            default:
                //Portrait
                message = kItemViewPortrait;
                break;
        }
        

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

-(BOOL) shouldAutorotate{
    return NO;
}



@end
