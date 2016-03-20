//
//  DessertDetailViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/10/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "HotelsViewController.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface HotelsViewController(){
    AppDelegate *appDelegate;
    NSArray *hotels ;
    UIImageView *selectedImageView;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation HotelsViewController



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
    
    NSInteger orderItems        = 0,
              currentOrderCount = 0,
              dessertCount      = 0,
              itemsCount        = 0;
    
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
                    if (appDelegate.dessertItems){
                        dessertCount = [[appDelegate.dessertItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:dessertCount];
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
        
        if (! hotels){
            hotels = [[NSArray alloc] initWithObjects: @"Block Hotel",@"Cabana Hotel",@"Eastin Hotel",@"Hyatt House Hotel",
                                                                                @"Hilton Hotel",@"Radisson Hotel", @"Regal Airport Hotel", @"Safari Court Hotel",
                                                                                @"Sheraton Suites Hotel",@"The Towers Hotel",nil];
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
    
    NSInteger calories =  arc4random_uniform(360);
    
    cal = [NSString stringWithFormat:cal,calories];
    
    return cal;
    
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cbHotels",
                   *restaurantName = @"",
                    *locationFormat = @"%d %@, Atlanta, GA, 30320" ,
                    *restaurantImageNameFormat = @"AirportHotels_%d.jpg",
                    *restaurantImageName = @"",
                    *terminal = @"",
                    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"Street", @"Avenue", @"Boulevard", @"Lane", @"Plaza", @"Road", nil];
    
    NSInteger terminalId = arc4random_uniform(Terminals.count),
                     gateId = arc4random_uniform(1450),
                     distanceId = arc4random_uniform(25),
                     imageId = 1;
    
    if (distanceId ==0){
        distanceId = 1;
    }
    
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
    restaurantName = [hotels objectAtIndex:indexPath.row];
    finalLocation = [NSString stringWithFormat:locationFormat, gateId,terminal];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %d %@",restaurantName,distanceId, (distanceId > 1 ? @"Miles" : @"Mile")]];
    [cell.detailTextLabel setText:finalLocation];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryView.tintColor = [UIColor whiteColor];
 //   [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
    
        [Utilities setParseImageCell:appDelegate.hotelbackgrounds anyIndex:indexPath.row tableCell:cell];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            
            [Utilities setParseImageCell:appDelegate.hotelbackgrounds anyIndex:indexPath.row tableCell:cell];
            UIImage *cellImage = nil;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(100, 50)];
                }
                /*    [cell.imageView setImage:cellImage];
                 [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:14.0f]];
                 [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:12.0f]];*/
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
    
    
    if (selectedCell.imageView){
        selectedImageView = selectedCell.imageView;
    }
    
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {
        
        if (item){
            [item.FlightLabel     setText:@""];
            [item.FlightLabel setAlpha:0.3f];
            
            [item.TerminalLabel setText:@""];
            [item.TerminalLabel  setAlpha:0.3f];
            
            [item.StatusLabel    setText:@""];
            [item.StatusLabel  setAlpha:0.3f];
            
            [item.AircraftLabel setText:@""];
            [item.AircraftLabel  setAlpha:0.3f];
        }
        
        [item.imageView setImage:image];
        
        NSString *rndFoodImgFormat    = @"Hotel_%d.jpg",
                        *rndFoodImgName      = @"",
                        *shopTypeImageName = @"";
        
        NSInteger rndFoodImgId = arc4random_uniform(8),
                          rndMiles = arc4random_uniform(25);
        
        if (rndFoodImgId == 0){
            rndFoodImgId =1;
        }
        
        if (rndMiles == 0){
            rndMiles = 1;
        }
        
        rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId];
        
        [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
        [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor colorWithHexString:@"f0f0f0"];
        [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
        

        [item setFoodType:Dining];
        
    
      NSArray *cuisines =   [[NSArray alloc] initWithObjects:@"Quiet Rooms", @"Mail Services",@"Shuttle",@"Wi-Fi", @"News Papers", @"Fax Machines",
                   @"Taxis", @"5 Star Hotel",@"Internet Stations", @"Room Service",nil],
                                *cuisineImages =  [[NSArray alloc] initWithObjects:@"hotel_information-100.png",@"post_office-100.png",@"bus-100.png",@"WiFi_logo_filled-100.png", @"news-100.png", @"copy-100.png", @"taxi-100.png", @"5_star_hotel-100.png",@"workstation_filled-100.png",@"bell_service-100.png",nil],

                       *prices    = [[NSArray alloc] initWithObjects:@"", @"Taxi", @"Tram", nil],
                       *ratings  = [[NSArray alloc] initWithObjects:@"Online CheckIn", nil];
        
        NSInteger cuisineId = arc4random_uniform(cuisines.count),
                          priceId     = arc4random_uniform(prices.count),
                          rateId      = arc4random_uniform(ratings.count);
        

        shopTypeImageName = [cuisineImages objectAtIndex:cuisineId];
        [item.ArrDepIMGView setImage:[UIImage imageNamed:shopTypeImageName]];
        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];
        [item.weatherIMGView setImage:[UIImage imageNamed:shopTypeImageName]];
        [item.weatherIMGView setHidden:YES];
        
        NSString  *cuisine  =  [cuisines objectAtIndex:cuisineId],
                        *price     =  [prices objectAtIndex:priceId],
                        *phone    = [ItemViewController generateRandomPhone],
                        *rating   =   [ratings objectAtIndex:rateId],
                        *hours    =  [NSString stringWithFormat:@"%d %@",rndMiles, (rndMiles > 1 ? @"Miles":  @"Mile")],
                        *site        = [NSString stringWithFormat:@"www.%@.com", [title stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        
        NSArray *siteNameData = [site componentsSeparatedByString:@"-"];
                        site = [siteNameData firstObject];
                        site = [site stringByAppendingString:@".com"];
        
        NSArray *titleSplit = [title componentsSeparatedByString:@"- "];
        
        if (titleSplit){
            [item setTitle: [titleSplit firstObject]];
            hours = [titleSplit lastObject];
        }
        
        [item.TempValue setText:cuisine];
        [item.WeatherValue setText:cuisine];
        
        [item.WeatherValue setHidden:YES];
        [item.Arrival_DepartureValue setText:rating];
        
        
        price = @"ROP\n (Reserve, Order & Pay)";
        [item.TempValue setNumberOfLines:0];
        [item.TempValue setText:price];
        
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
        
        NSString *hotelDistanceLabel = (appDelegate.isiPhone ? @"Hotel\nDistance:": @"Hotel Distance: ");
        
        [item.FlightLabel setText:hotelDistanceLabel];
        
        if (appDelegate.isiPhone){
            hours = [NSString stringWithFormat:@"\n%@",hours];
        }
        [item.FlightValue setText:hours];
        
        NSString *hotelAddressLabel = (appDelegate.isiPhone ? @"Hotel\nAddress:": @"Hotel Address: ");
        [item.TerminalLabel setText:hotelAddressLabel];
        
        [item.TerminalValue setText: [desc stringByReplacingOccurrencesOfString:@"Located in Terminal " withString:@""]];
        if (appDelegate.isiPhone){
            item.TerminalValue.text = [NSString stringWithFormat:@"\n%@",item.TerminalValue.text];
        }
        
        

        [item.instructionsLabel setText:[titleSplit firstObject]];
        [item.StatusLabel setText:@"Phone Number: "];
        if (appDelegate.isiPhone){
            phone = [NSString stringWithFormat:@"\n%@",phone];
        }
        [item.StatusValue setText:phone];
        [item.AircraftLabel setText:@"Web Site: "];
        [item.AircraftValue setText:[site stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
    [item startRandomStatus:cuisines :cuisineImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
        
     //   if (appDelegate.isDynamic){
            [ item startTimer:rndFoodImgFormat :5];
       // }

        [item.FlightLabel setAlpha:1.0f];
        [item.TerminalLabel  setAlpha:1.0f];
        [item.StatusLabel  setAlpha:1.0f];
        [item.AircraftLabel  setAlpha:1.0f];
        
    }];
}

- (IBAction)actionReserveClicked:(UIButton *)sender {
    UIAlertView *alert = nil;
    @try {
        alert = [[UIAlertView alloc] initWithTitle:@"Reserve, Order and Pay"
                                           message:@"Coming soon..."
                                          delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        
        [alert show];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        alert = nil;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 1;
    
    switch (section) {
        case 0:
            rowCount = 9 ;
            break;
    }
    return rowCount;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkOrderCount];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Nearby Hotels"]];
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

@end
