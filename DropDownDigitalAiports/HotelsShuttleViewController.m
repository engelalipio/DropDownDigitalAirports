//
//  DessertDetailViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/10/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "HotelsShuttleViewController.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface HotelsShuttleViewController(){
    AppDelegate *appDelegate;
    NSArray *hotels ;
    NSMutableArray  *shuttles;
    UIImageView *selectedImageView;
    NSString *selectedShuttle;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation HotelsShuttleViewController

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSString  *message = @"",
                     *trimName = selectedShuttle;
    
    NSArray  *randomData  = [[NSArray alloc] initWithObjects:
                             [NSString stringWithFormat:@"%@'s shuttle is on the way!", selectedShuttle],
                             [NSString stringWithFormat:@"Please proceed to %@'s shuttle located outside each terminal.",trimName],nil];
    
    UIAlertView *alert = nil;
    
    UITableViewCell *cell = nil;
    UIImageView *accView = nil;
    
    NSInteger index= -1;
    @try {
        
        index = self.tableView.indexPathForSelectedRow.row;
        
        switch (buttonIndex) {
            case 0:
                selectedShuttle = nil;
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
                break;
            case 1:
                message = [randomData objectAtIndex:arc4random_uniform(randomData.count)];
                break;
        }
        
        if ([message length] > 0){
            
            alert =  [[UIAlertView alloc] initWithTitle:@"Your Request Has Been Received"
                                                message:message
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
                if (alert){
                        [alert show];
                    }
        
             cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
            message = [hotels objectAtIndex:index];
            
            if (cell){
                accView =  (UIImageView *)[cell accessoryView];
                if (accView){
                   [ accView setImage:[UIImage imageNamed:@"walkie_talkie_radio_filled-25.png"]];
                }else{
                   accView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walkie_talkie_radio_filled-25.png"]];
                }
            [cell setAccessoryView:accView];
                if ([message isEqualToString:selectedShuttle]){
                    
                    [shuttles setObject:@"" atIndexedSubscript:index];
                }
            }
        
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
        alert        = nil;
    }
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
            hotels = [[NSArray alloc] initWithObjects: @"Block Hotel",@"Cabana Hotel",@"Eastin Hotel",@"Glass Palace Hotel",
                                                                                @"Hilton Hotel",@"Radisson Hotel", @"Regal Airport Hotel", @"Safari Court Hotel",
                                                                                @"Sheraton Suites Hotel",@"The Towers Hotel",nil];
            
            shuttles = [[NSMutableArray alloc] initWithArray:hotels];
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

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
            [header setText:@"Airport Hotel Shuttle Services"];
            [self.navigationItem setTitleView:nil];
            [self setTitle:@""];
            [self.navigationItem setTitle:@""];
            break;
    }
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cbHotelsShuttle",
                   *restaurantName = @"",
                    *locationFormat = @"%d %@, Atlanta, GA, 30320" ,
                    *restaurantImageNameFormat = @"AirportHotels_%d.jpg",
                    *restaurantImageName = @"",
                    *terminal = @"",
                    *finalLocation = @"",
                    *phone = @"";
    
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

    phone = [ItemViewController generateRandomPhone];
    
    [cell.textLabel setText:phone];
    
    finalLocation   = [NSString stringWithFormat:@"http://www.%@.com", [restaurantName stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    finalLocation =  [finalLocation stringByReplacingOccurrencesOfString:@" " withString:@""];
    [cell.detailTextLabel setText:finalLocation];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    UIImageView *accView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walkie_talkie_radio-25.png"]];
    
    [cell setAccessoryView:accView];
 
   // [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
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
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90, 45)];
                }
                /*    [cell.imageView setImage:cellImage];
                 [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:14.0f]];
                 [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:12.0f]];*/
            }        }
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message = @"";
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}


-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSString *message  =@"",
                    *hotelName = @"",
                    *pShuttle = @"",
                    *shuttleName = @"";
    
    UIAlertView *alert = nil;
    
    BOOL hasSelection = NO;
    
    @try {
        hotelName =  [hotels objectAtIndex:indexPath.row];
        
        shuttleName = selectedShuttle;
        
        if ([shuttles containsObject:pShuttle]){
            hasSelection = YES;
        }
    
        
        if (! shuttleName && ! hasSelection){
            message = [NSString stringWithFormat:@"Press Ok To Contact %@'s Shuttle Service", hotelName];
        
            alert =[ [UIAlertView alloc] initWithTitle:hotelName
                                                            message:message
                                                            delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok", nil];
            
        selectedShuttle = hotelName;
            
        }else{
            
            
            
            alert =[ [UIAlertView alloc] initWithTitle:@"Airport shuttle services have already been contacted."
                                               message:@"Please contact the hotel directly for any additional questions or concerns."
                                              delegate:self
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
        }
        
        if (alert){
            [alert show];
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
        alert = nil;
    }
}

- (IBAction)actionReserveClicked:(UIButton *)sender {
    NSURL  *url= nil;
    
    NSString *message= @"",
                    *launchURL = @"";
    
    @try {
        
        
        launchURL =kOMSN;
        
        url=  [[NSURL alloc] initWithString:launchURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            message = [NSString stringWithFormat:@"Launching OMSN App-> %@",url];
        }else{
            url=  [[NSURL alloc] initWithString:kOMSN];
            message = [NSString stringWithFormat:@"Launching OMSN Web-> %@",url];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        url = nil;
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
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Airport Hotel Shuttle Services"]];
}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentJustified];
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
