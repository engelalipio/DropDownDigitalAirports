//
//  SightseeingViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/5/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "SightseeingViewController.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface SightseeingViewController ()
{
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
    NSArray *lounges;
    NSString *selectedRestaurant;
}
-(void) initTableView;
@end

@implementation SightseeingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"SightSeeing Attractions"]];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGRect)approximateFrameForTabBarItemAtIndex:(NSUInteger)barItemIndex inTabBar:(UITabBar *)tabBar {
    
    CGRect tabBarRect;
    
    NSArray *barItems = nil;
    
    NSString *message = @"";
    
    CGFloat barMidX = 0.0f,
            distanceBetweenBarItems = 0.0f,
            totalBarItemsWidth = 0.0f,
            barItemX = 0.0f;
    
    CGSize  barItemSize;
    
    @try {
        
        barItems = tabBar.items;
        
        barMidX = CGRectGetMidX([tabBar frame]);
        
        barItemSize = CGSizeMake(80.0, 45.0);
        
        distanceBetweenBarItems = 110.0;
        
        barItemX = barItemIndex * distanceBetweenBarItems + barItemSize.width * 0.5;
        
        totalBarItemsWidth = ([barItems count]-1) * distanceBetweenBarItems + barItemSize.width;
        
        barItemX += barMidX - round(totalBarItemsWidth * 0.5);
        
        tabBarRect =  CGRectMake(barItemX, CGRectGetMinY([tabBar frame]), 30.0, barItemSize.height);
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        
        barItems = nil;
        
        message = @"";
        
        barMidX = 0.0f;
        distanceBetweenBarItems = 0.0f;
        totalBarItemsWidth = 0.0f;
        barItemX = 0.0f;
        
    }
    
    return tabBarRect;
}

- (void) initiateAddToCart:(NSInteger) orderItems{
    
    
    static float const curvingIntoCartAnimationDuration = kAnimationSpeed;
    
    CALayer *layerToAnimate = nil;
    
    CAKeyframeAnimation *itemViewCurvingIntoCartAnimation = nil;
    
    CABasicAnimation    *itemViewShrinkingAnimation = nil,
                        *itemAlphaFadeAnimation     = nil;
    
    CAAnimationGroup    *shrinkFadeAndCurveAnimation = nil;
    
    NSString *message = @"";
    
    @try {
        
        
        //Obtaining the Image Layer to animate
        
        layerToAnimate = selectedImageView.layer;
        
        itemViewCurvingIntoCartAnimation = [self itemViewCurvingIntoCartAnimation];
        
        
        itemViewShrinkingAnimation =  [CABasicAnimation animationWithKeyPath:@"bounds"];
        
        itemViewShrinkingAnimation.toValue = [NSValue valueWithCGRect:
                                              CGRectMake(0.0,0.0, selectedImageView.bounds.size.width/2.5,
                                                         selectedImageView.bounds.size.height/2.5)];
        
        itemAlphaFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        itemAlphaFadeAnimation.toValue = [NSNumber numberWithFloat:0.5];
        
        shrinkFadeAndCurveAnimation = [CAAnimationGroup animation];
        
        [shrinkFadeAndCurveAnimation setAnimations:[NSArray arrayWithObjects:
                                                    itemViewCurvingIntoCartAnimation,
                                                    itemViewShrinkingAnimation,
                                                    itemAlphaFadeAnimation,
                                                    nil]];
        
        [shrinkFadeAndCurveAnimation setRepeatCount:orderItems];
        [shrinkFadeAndCurveAnimation setDuration:curvingIntoCartAnimationDuration];
        [shrinkFadeAndCurveAnimation setDelegate:self];
        [shrinkFadeAndCurveAnimation setRemovedOnCompletion:NO];
        [shrinkFadeAndCurveAnimation setValue:@"shrinkAndCurveToAddToOrderAnimation" forKey:@"name"];
        
        [layerToAnimate addAnimation:shrinkFadeAndCurveAnimation forKey:nil];
        
        
        
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

- (CAKeyframeAnimation *) itemViewCurvingIntoCartAnimation {
    
    NSString *message =@"";
    
    float riseAbovePoint = 300.0f;
    
    CGRect positionOfItemViewInView,
    orderTableItemRect;
    
    CGPoint beginningPointOfQuadCurve,
            endPointOfQuadCurve,
            controlPointOfQuadCurve;
    
    UIBezierPath * quadBezierPathOfAnimation = nil;
    
    CAKeyframeAnimation * itemViewCurvingIntoCartAnimation ;
    
    UITabBarItem *orderTabItem = nil;
    
    @try {
        
        //Originating Image
        positionOfItemViewInView = selectedImageView.frame;
        
        orderTabItem = (UITabBarItem*)  [[[self.tabBarController tabBar] items] objectAtIndex:kOrderTabItemIndex];
        
        orderTableItemRect = [self approximateFrameForTabBarItemAtIndex:kOrderTabItemIndex inTabBar:self.tabBarController.tabBar];
        
        UIImageView *orderImage = [[UIImageView alloc ] initWithFrame:orderTableItemRect];
        
        if (orderImage){
            [orderImage setImage:orderTabItem.image];
        }
        
        beginningPointOfQuadCurve = positionOfItemViewInView.origin;
        
        endPointOfQuadCurve = CGPointMake(orderImage.frame.origin.x + orderImage.frame.size.width/2,
                                          orderImage.frame.origin.y + orderImage.frame.size.height/2) ;
        
        controlPointOfQuadCurve = CGPointMake((beginningPointOfQuadCurve.x + endPointOfQuadCurve.x *2)/2,
                                              beginningPointOfQuadCurve.y -riseAbovePoint);
        
        quadBezierPathOfAnimation = [UIBezierPath bezierPath];
        
        [quadBezierPathOfAnimation moveToPoint:beginningPointOfQuadCurve];
        
        [quadBezierPathOfAnimation addQuadCurveToPoint:endPointOfQuadCurve controlPoint:controlPointOfQuadCurve];
        
        itemViewCurvingIntoCartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        itemViewCurvingIntoCartAnimation.path = quadBezierPathOfAnimation.CGPath;
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message = @"";
    }
    
    
    return itemViewCurvingIntoCartAnimation;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSString *message   = @"",
             *orderItem = @"";
    
    NSInteger orderItems        = 0,
              currentOrderCount = 0,
             itemsCount        = 0;
    
    @try {
        
        itemsCount = kOrderTabItemIndex;
        
        currentOrderCount = [appDelegate currentOrderItems];
        if (! currentOrderCount){
            currentOrderCount = 0;
            [appDelegate setCurrentOrderItems:currentOrderCount];
        }
        orderItem = [NSString stringWithFormat:@"%d",currentOrderCount];
        [[[[self.tabBarController tabBar] items] objectAtIndex:itemsCount] setBadgeValue:orderItem];
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message   = @"";
        orderItem = @"";
        
        orderItems = 0;
        itemsCount = 0;
    }
    
}

-(void)checkOrderCount{
    
    NSString *message   = @"",
    *orderItem = @"";
    
    NSInteger orderItems      = 0,
    currentOrderCount = 0,
    saladCount        = 0,
    itemsCount       = 0;
    
    @try {
        
        itemsCount = kOrderTabItemIndex;
        
        if (! appDelegate){
              appDelegate = [AppDelegate currentDelegate];
        }
        
        currentOrderCount = [appDelegate currentOrderItems];
        if (! currentOrderCount){
            currentOrderCount = 0;
            [appDelegate setCurrentOrderItems:currentOrderCount];
        }
        
        orderItem =  [[[[self.tabBarController tabBar] items] objectAtIndex:itemsCount] badgeValue];
        if (! orderItem){
            orderItem = @"0";
        }
        if (orderItem){
            
            orderItems = [orderItem intValue];
            if (orderItems < currentOrderCount){
                
                orderItems = currentOrderCount;
                
                if (selectedImageView != nil){
                    if (appDelegate.saladItems){
                        saladCount = [[appDelegate.saladItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:saladCount];
                    }
                }
                
            }
        }
        
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message   = @"";
        orderItem = @"";
        
        orderItems = 0;
        itemsCount = 0;
    }
    
}

#pragma -mark Table View Events


-(void) initTableView{
    
    NSString *message = @"";
    
    @try{
        
        if (! lounges){
            lounges =[ [NSArray alloc] initWithObjects:@"The Staten Island Ferry",
                      @"Kayak Excursions", @"Big Sur Cliff", @"Hot Air Balloon Rides", @"San Franscisco Trolley",
                      @"Elephant Experience",@"Rapa Nui Climbs",  @"The Redeemer Statue",@"Castle Explorations", @"Double Decker Bus",nil];
        }
        
        if (! self.tableView){
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, kTableYStart, kTabletWidth, kTableHeight)];
        }
        
        
        self.tableView.backgroundColor =  kVerticalTableBackgroundColor;
        
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


-(NSString*) randomCalories{
    NSString *cal  =  @"%d calories";
    
    NSInteger calories =  arc4random_uniform(150);
    
    cal = [NSString stringWithFormat:cal,calories];
    
    return cal;
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cbLounges",
                    *restaurantName = @"",
                    *locationFormat = @"Located in Terminal %@ - Near to Gate %d" ,
                    *restaurantImageNameFormat = @"Club_%d.jpg",
                    *restaurantImageName = @"",
                    *terminal = @"",
                    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"N", @"C",  @"S", nil];
    
    NSInteger terminalId = arc4random_uniform(Terminals.count),
                     gateId = arc4random_uniform(50),
                     imageId = 0;
    
    if (gateId == 0){
        gateId = 1;
    }
    
    cell =  [tableView  dequeueReusableCellWithIdentifier:cellID];
    imageId = indexPath.row;

    
    terminal = [Terminals objectAtIndex:terminalId];
    
    if (! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }
    restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,imageId];
    restaurantName = [lounges objectAtIndex:indexPath.row];
    terminal = [NSString stringWithFormat:@"%@",terminal];
    finalLocation =  [Utilities getParseColumnValue:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row anyColumn:@"ImageDesc"];
    [cell.textLabel setText:restaurantName];
    [cell.detailTextLabel setText:finalLocation];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryView.tintColor = [UIColor whiteColor];

        
        UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row];
        
        [cell.imageView setImage:cellImage];
  
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            
            [Utilities setParseImageCell:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row tableCell:cell];
            UIImage *cellImage = nil;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(100, 50)];
                }

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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemViewController *item = [[ItemViewController alloc] init];
    [item setFoodType:Lounge];
    NSString *price = @"$0.00",
                    *title = @"",
                    *data  = @"",
                    *desc  = @"";
    
    UIImage *image = nil;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell){
        UIView *contentView = selectedCell.contentView;
        
        if (contentView){
            NSArray *subViews =  [contentView subviews];
            
            for (int viewCounter = 0; viewCounter < subViews.count; viewCounter++) {
                
                UIView *subView = [subViews objectAtIndex:viewCounter];
                
                if ([subView isKindOfClass:[UILabel class]]){
                    
                    UILabel *label = (UILabel*) subView;
                    
                    NSRange range = [label.text rangeOfString:@"$"];
                    
                    if ( range.location != NSNotFound){
                        price = [label.text substringFromIndex:1];
                        
                    }else{
                        
                        data = label.text;
                        
                        if ([title length] == 0){
                            title  = data;
                        }else{
                            if (data.length > 0){
                                desc = data;
                            }
                            
                            if ([title length] > 0 && [desc length] > [title length]){
                                if (data.length > 0){
                                    desc = data;
                                }
                            }
                        }
                        
                    }
                    
                }
                
                if ([subView isKindOfClass:[UIImageView class]]){
                    
                    UIImageView *imageV = (UIImageView*) subView;
                    
                    image = [imageV image];
                    
                }
                
            }
            
        }
    }
    
    if (item){
        [item.FlightLabel setText:@""];
        [item.TerminalLabel setText:@""];
        [item.StatusLabel setText:@""];
        [item.AircraftLabel setText:@""];
    }
    
    if (selectedCell.imageView){
        selectedImageView = selectedCell.imageView;
    }
    
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {
        
        [item.imageView setImage:image];
        
        
        NSString *rndFoodImgFormat    = @"Airline_%d.gif",
                        *rndFoodImgName      = @"",
                        *shopTypeImageName = @"";
        
        NSInteger rndFoodImgId =  indexPath.row;
        
        
     //   rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId];
        
        [item.AirlineIMGView setImage:image];
        [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
        [item setFoodType:Dining];
        
        NSArray *cuisines = [[NSArray alloc] initWithObjects:title,nil],
                      *cuisineImages =  [[NSArray alloc] initWithObjects:@"",nil],
                      *prices    = [[NSArray alloc] initWithObjects:@"Gourmet Menu", @"Waiter Staff", nil],
                      *ratings  = [[NSArray alloc] initWithObjects:@"Available", nil];
        
        NSInteger cuisineId = arc4random_uniform(cuisines.count),
                          priceId     = arc4random_uniform(prices.count),
                          rateId      = arc4random_uniform(ratings.count);
        
        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];
        
        switch (indexPath.row) {
            case 0:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"ferry_filled.png",nil];
                break;
            case 1:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"paddling_filled.png",nil];
                break;
            case 2:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"earth_element_filled.png",nil];
                break;
            case 3:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"hot_air_balloon_filled.png",nil];
                break;
            case 4:
                 cuisineImages =  [[NSArray alloc] initWithObjects:@"train_filled.png",nil];
                break;
            case 5:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"elephant_filled.png",nil];
                break;
            case 6:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"earth_element_filled.png",nil];
                break;
            case 7:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"cross_filled.png",nil];
                break;
            case 8:
                cuisineImages =  [[NSArray alloc] initWithObjects:@"palace_filled.png",nil];
                break;
            case 9:
                 cuisineImages =  [[NSArray alloc] initWithObjects:@"bus_filled.png",nil];
                break;
            
        }
        
        shopTypeImageName = [cuisineImages objectAtIndex:cuisineId];
        
        [item.ArrDepIMGView setImage:[UIImage imageNamed:shopTypeImageName]];
        [item.weatherIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];
        [item.weatherIMGView setHidden:YES];
        [item.WeatherValue setHidden:YES];
        
        NSString *cuisine = [cuisines objectAtIndex:cuisineId],
                        *price =   [Utilities getParseColumnValue:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row anyColumn:@"Price"],
                        *rating = [ratings objectAtIndex:rateId],
                        *phone    = [ItemViewController generateRandomPhone],
                        *hours  =  [Utilities getParseColumnValue:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row anyColumn:@"Hours"],
                        *site    =  [Utilities getParseColumnValue:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row anyColumn:@"URL"],
                        *desc =  [Utilities getParseColumnValue:appDelegate.sightseeingbackgrounds anyIndex:indexPath.row anyColumn:@"ImageDesc"];
        
                        [title stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        [item.TempValue setText:cuisine];

        rating = @"R.O.P.\n (Reserve, Order & Pay)";
        [item.TempValue setNumberOfLines:0];
        [item.TempValue setText:rating];
        
        CGRect btnFrame = CGRectMake(item.TempIMGView.frame.origin.x,
                                     item.TempIMGView.frame.origin.y,
                                     item.TempIMGView.frame.size.width ,
                                     item.TempIMGView.frame.size.height);
        
        UIButton *btnReserve = [[UIButton alloc] initWithFrame:btnFrame];
        
        if (btnReserve){
            [btnReserve setBackgroundImage:item.TempIMGView.image forState:UIControlStateNormal];
            [btnReserve  setUserInteractionEnabled:YES];
            [btnReserve setShowsTouchWhenHighlighted:YES];
            
            [btnReserve addTarget:self action:@selector(actionReserveClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [item.TempIMGView setHidden:YES];
            [item.view addSubview:btnReserve];
            [item.view bringSubviewToFront:btnReserve];
            
        }
        
        [item.Arrival_DepartureValue setText:cuisine];
        
        [item.FlightLabel setText:@"Hours: "];
        
        [item.FlightValue setText:hours];
        
        selectedRestaurant =  title;
        
        [item.instructionsLabel setText:title];
        [item.StatusLabel setText:@"Phone: "];
        [item.TerminalLabel setText:@"Price:"];
        
      //  price = [price stringByAppendingString:@"\n\n\n"];
        
        [item.TerminalValue setText: price];
      //  item.TerminalValue.text =  [NSString stringWithFormat:@"\n%@",item.TerminalValue.text];
        if (appDelegate.isiPhone){

            switch (appDelegate.screenHeight) {
                case 736:
                    //tread as ipad
                    

                    if (desc.length >= 39){
                        [item.TerminalValue setNumberOfLines:0];
                        [item.TerminalValue  setFont:[UIFont systemFontOfSize:14.5f]];
                    }
                    
                    if (site.length >= 39){
                        [item.AircraftValue setNumberOfLines:0];
                        [item.AircraftValue  setFont:[UIFont systemFontOfSize:12.5f]];
                    }
                    
                    break;
                    
                default:
                    phone = [NSString stringWithFormat:@"\n%@",phone];
                    

                    
                    break;
            
            }
        }else{
            [item.TerminalLabel setNumberOfLines:0];
            item.TerminalLabel.text =  [item.TerminalLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"/\n"];
        }
        
        [item.StatusValue setText:phone];
        [item.AircraftLabel setText:@"Web Site: "];
        [item.AircraftValue setText:[site stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        [item startRandomStatus:cuisines :cuisineImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
        
        //if (appDelegate.isDynamic){
         //   [ item startTimer:rndFoodImgFormat :8];
       // }
        
    }];
}


- (IBAction)actionReserveClicked:(UIButton *)sender {
    NSURL  *url= nil;
    
    NSString *currentName = @"",
    *message     = @"",
    *launchURL   = @"";
    
    NSArray<NSString *> *searchCrit = nil;
    @try {
        
        //currentName = selectedStore;
        currentName = @"Attractions";
        
        /* searchCrit = [currentName componentsSeparatedByString:@" "];
         
         if (searchCrit.count > 0){
         currentName = [searchCrit firstObject];
         }*/
        
        if ([currentName length] > 0){
            currentName = [currentName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSLog(@"Invoking kOMSENApp from Airport App for %@",currentName);
        }
        
        launchURL = [NSString stringWithFormat:@"%@?term=%@",kOMSENApp,currentName];
        
        message = [NSString stringWithFormat:@"Airport:Attractions:ROP->%@",launchURL];
        
        [MSAnalytics trackEvent:message];
        
        url=  [[NSURL alloc] initWithString:launchURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            message = [NSString stringWithFormat:@"Launching kOMSENApp App-> %@",url];
        }else{
            url=  [[NSURL alloc] initWithString:kOMSN];
            message = [NSString stringWithFormat:@"Launching kOMSENApp Web-> %@",url];
        }
        [MSAnalytics trackEvent:message];
        [[UIApplication sharedApplication] openURL:url];
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        url = nil;
    }


}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:@"Avenir Roman" size:18.0f]];
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


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"SightSeeing Attractions"]];
    [self checkOrderCount];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return lounges.count;
}

@end
