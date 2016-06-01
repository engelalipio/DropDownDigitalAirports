//
//  MenuDetailViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/5/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//
#import "FlightsViewController.h"
#import "AirlinesViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "DataModels.h"

@interface AirlinesViewController ()
{
    NSMutableArray *menuTitles,
                                *arrivals,
                                *departures,
                                *airlines;
    
    AppDelegate *appDelegate;
    
    UIImageView *selectedImageView;
    
    NSString *airlineName,
                    *airlineLogo;
    
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation AirlinesViewController
 
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
    
    NSInteger orderItems    = 0,
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
              drinksCount       = 0,
              itemsCount        = 0;
    
    @try {
        
        itemsCount = kOrderTabItemIndex;
        

        
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
                    if (appDelegate.drinkItems){
                        drinksCount = [[appDelegate.drinkItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:drinksCount];
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
    
    NSInteger calories =  arc4random_uniform(200);
    
    cal = [NSString stringWithFormat:cal,calories];
    
    return cal;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerH = 30.0f;
    
    return headerH;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    NSInteger size = 20.0f;
    
    NSTextAlignment alignment = NSTextAlignmentCenter;
    
    
    if (appDelegate.isiPhone){
        size = 15.0f;
    }
    switch (section) {
        case 0:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setText:[NSString stringWithFormat:@"%lu Total Airline(s)",(unsigned long)airlines.count]];
            break;

    }
    return header;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    FidsData *fidsData = [[FidsData alloc] init];
    
    //airlineName,airlineLogoUrlPng,flightNumber,city,currentTime,gate,terminal,baggage,remarks,weather,destinationFamiliarName"
    
    NSString *cellID = @"cbFlights",
                    *airlineLogoUrlPng  = @"",
                    *flightNumber = @"",
                    *city  =@"",
                    *currentTime  =@"",
                    *gate = @"",
                    *baggage  =@"",
                    *remarks  =@"",
                    *weather  =@"",
                    *destinationFamiliarName = @"",
                    *terminal = @"",
                    *finalLocation = @"";
    
    UIImage *image = nil;

    
    int row = 0;
    
    if (indexPath.row){
        row = indexPath.row;
    }
 
    fidsData =  [airlines objectAtIndex:row];
    
    
    cell =  [tableView  dequeueReusableCellWithIdentifier:cellID];
 

    if (! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }
    
 
    airlineName = [fidsData airlineName];
    airlineLogoUrlPng = [fidsData airlineLogoUrlPng];
    flightNumber = [fidsData flightNumber];
    city = [fidsData city];
    currentTime = [fidsData currentTime];
    gate = [fidsData gate];
    if (! gate){
        gate = @"tbd";
    }
    baggage = [fidsData baggage];
    remarks = [fidsData remarks];
    
    if (remarks){
        destinationFamiliarName = [destinationFamiliarName stringByReplacingOccurrencesOfString:@"Arriving" withString:remarks];
        destinationFamiliarName = [destinationFamiliarName stringByReplacingOccurrencesOfString:@"Departing" withString:remarks];
    }
    
    weather = [fidsData weather];

    terminal = [fidsData terminal];
    if (!terminal){
        terminal = @"tbd";
    }
    
    if (airlineLogoUrlPng){
        NSURL *url  = [[NSURL alloc] initWithString:airlineLogoUrlPng];
        if (url){
 
            NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
            if (imageData){
                image  = [UIImage imageWithData:imageData];
                
                if (appDelegate.isiPhone){
                     image  = [Utilities imageResize:image andResizeTo:CGSizeMake(90.0f, 45.0f)];
                }else{
                    image  = [Utilities imageResize:image andResizeTo:CGSizeMake(150.0f, 50.0f)];
                }
            }
        }
    }
 

    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"airlineName like %@", airlineName],
                          *dPredic = [NSPredicate predicateWithFormat:@"airlineLogoUrlPng like %@", airlineLogoUrlPng];
    
 
    
    int arrivalCount = 0,
    departureCount = 0;
    
    NSArray *fArrivals =  [arrivals filteredArrayUsingPredicate:predicate],
                    *fDepartures = [departures filteredArrayUsingPredicate:dPredic];
    
    if (fArrivals){
        arrivalCount = fArrivals.count;
    }

    if (fDepartures){
        departureCount = fDepartures.count;
    }
    
    NSDate *today = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                   dateFormatter.timeStyle = NSDateFormatterNoStyle;
                                   dateFormatter.dateStyle = NSDateIntervalFormatterShortStyle;
    
   NSString *strToday = [dateFormatter stringFromDate:today];
    
   finalLocation = [NSString stringWithFormat:@"%lu Arrival(s) | %d Departure(s)",(unsigned long)arrivalCount,departureCount];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ Available Flight(s) for %@ ",airlineName,strToday]] ;
    [cell.detailTextLabel setText:finalLocation];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryView.tintColor = [UIColor whiteColor];
    [cell.imageView setImage:image];
    
    return cell;
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
                if (cellImage){
              //      cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90,50)];
                    if (cellImage.size.width > 200.0f){
                        cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(80,cellImage.size.height / 2)];
                        [cell.imageView setImage:cellImage];
                    }
                }
        
               [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:12.0f]];
               [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:11.0f]];
            }else{
                
             /*   [cell.imageView setFrame:CGRectMake( cell.imageView.frame.size.width/3 - 15.0f,  cell.imageView.frame.origin.y,
                                                          cell.imageView.frame.size.width, cell.imageView.frame.size.height)];*/
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
    
 
    FidsData *fData =  (FidsData*) [airlines objectAtIndex:indexPath.row];
    
    airlineName = fData.airlineName;
    airlineLogo = fData.airlineLogoUrlPng;
    
    if (appDelegate){
        [appDelegate setSelectedAirlineName:airlineName];
        [appDelegate setSelectedAirlineLogo:airlineLogo];
    }
    
    
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (section) {
     case 0:
            rowCount = airlines.count;
     break;

     }
    return rowCount;
}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:kTitleColor];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:kTitleFont size:kTitleSize]];
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
    [self checkOrderCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    
    if (appDelegate){
        airlines = [appDelegate.airlines objectForKey:@"Airlines"];
        arrivals = [appDelegate.arrivals objectForKey:@"Arrivals"];
        departures = [appDelegate.departures objectForKey:@"Departures"];
    }
    
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Available Airlines"]];
    // Do any additional setup after loading the view.
    //[self roundLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    FlightsViewController *fVC = (FlightsViewController *) [segue destinationViewController];
    if (fVC){
        [appDelegate setSelectedAirlineName:airlineName];
        [appDelegate setSelectedAirlineLogo:airlineLogo];
    }
    
}


@end
