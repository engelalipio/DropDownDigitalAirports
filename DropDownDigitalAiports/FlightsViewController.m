//
//  MenuDetailViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/5/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "FlightsViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"

@interface FlightsViewController ()
{
    NSMutableArray *menuTitles;
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation FlightsViewController
 
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
    
    NSTextAlignment alignment = NSTextAlignmentRight;
    
    
    if (appDelegate.isiPhone){
        size = 15.0f;
        alignment = NSTextAlignmentCenter;
    }
    switch (section) {
        case 0:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setText:@"Arrival Times"];
            break;

        case 1:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextColor:[UIColor whiteColor]];
            [header setTextAlignment:alignment];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setText:@"Departure Times"];
            break;
    }
    return header;
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
        
                [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:14.0f]];
                [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:12.0f]];
            }
            
            
            if (cellImage != nil){
                NSArray *airlines =[ [NSArray alloc ] initWithObjects:@"varig.png", @"Southwest_Airlines.png", @"Air_Caribbean.png",
                @"IndiGo_Airlines.png", @"New_Swiss_International_Airlines.png", @"Korean_Air.png",@"AirJapan.png",
                @"AAirlines.png", @"Northwest_Airlines.png", @"Hawaiian_Airlines.png", @"JetBlue_Airways.png",@"Alaska_Airlines.png",
                @"Delta.png", @"Air_France.png",nil ];
                
                NSInteger rndImageNumber  = arc4random_uniform(airlines.count );
                NSString *rndImageName = [airlines objectAtIndex:rndImageNumber];
                cellImage = [UIImage imageNamed:rndImageName];
                if (! appDelegate){
                    appDelegate = [AppDelegate currentDelegate];
                }
               /* if (appDelegate.isDynamic){
                    [cell.imageView setImage:cellImage];
                }*/
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
    
    NSString
                    *flight = @"",
                    *gate  = @"",
                    *time   = @"",
                    *data  = @"" ,
                    *flightType = (indexPath.section == 0 ? @"A" : @"D"),
                    *randomImgName = [NSString stringWithFormat:@"%@_%d.jpg", flightType, indexPath.row];
    
    UIImage *image = [UIImage imageNamed:randomImgName];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell){
        UIView *contentView = selectedCell.contentView;
        
        if (contentView){
            NSArray *subViews =  [contentView subviews];
            
            for (int viewCounter = 0; viewCounter < subViews.count; viewCounter++) {
                
                UIView *subView = [subViews objectAtIndex:viewCounter];
                
                if ([subView isKindOfClass:[UILabel class]]){
                    
                    UILabel *label = (UILabel*) subView;
                                   data = label.text;

                    switch (viewCounter) {
                        case 0:
                            flight = data;
                            break;
                        case 1:
                            gate = data;
                            break;
                        case 2:
                            break;
                        case 3:
                            time  = data;
                            break;
                    }
                }
            }
        }
    }
    
    if (selectedCell.imageView){
        selectedImageView = selectedCell.imageView;
    }
    
   
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {

        UIImage *randomImg = image,
                       *weatherIMG = nil;
    
    
        NSArray *weatherData = [[NSArray alloc] initWithObjects:@"Sunny", @"Rainy", @"Windy", @"Overcast", @"Snow", @"Cloudy", @"Sleet", nil],
        
                        *instArrData = [[NSArray alloc] initWithObjects:@"Luggage Being Loaded to Baggage Belt", @"Landed", @"Delayed", nil],
        
                        *instDepData = [[NSArray alloc] initWithObjects:@"Departed", @"Gate Closing", @"Boarding",  @"Taxiing", nil],
        
                        *statusData = [[NSArray alloc] initWithObjects:@"On Schedule", @"Delayed", @"Maintenance Check", @"Restocking Aircraft",  nil],
        
                        *planeData = [[NSArray alloc] initWithObjects:@"Boeing 737 AirBus", @"Boeing 747-8",@"Boeing 727 AirMax",
                                                                                                    @"Boeing 777-X", @"Boeing 777 AirBus",  nil];
       
        NSInteger imageId =  arc4random_uniform(weatherData.count),
                         statusId  = arc4random_uniform(statusData.count),
                         instArrId = arc4random_uniform(instArrData.count),
                         instDepId = arc4random_uniform(instDepData.count),
                         planeId = arc4random_uniform(planeData.count),
                         tempLId   = arc4random_uniform(50),
                         tempHId   =  arc4random_uniform(100);
        
        if (tempLId <= 30){
            tempLId = 32;
        }
        if (tempHId <= tempLId){
            tempHId = tempLId + 10 ;
        }
        
        NSString  *weather = [weatherData objectAtIndex:imageId],
                        *status     = [statusData objectAtIndex:statusId],
                        *temp      = [NSString stringWithFormat:@"%dº L/ %dº H", tempLId,tempHId],
                        *instArr    = [instArrData objectAtIndex:instArrId],
                        *instDept     = [instDepData objectAtIndex:instDepId],
                        *instructions = @"",
                        *aircraft    = [planeData objectAtIndex:planeId];
        
        
        switch (imageId) {
            case 0:
                weatherIMG = [UIImage imageNamed:@"sun-100.png"];
                break;
            case 1:
                weatherIMG = [UIImage imageNamed:@"rain-100.png"];
                break;
            case 2:
                  weatherIMG = [UIImage imageNamed:@"air_element-100.png"];
                break;
            case 3:
                  weatherIMG = [UIImage imageNamed:@"partly_cloudy_day-100.png"];
                break;
            case 4:
                  weatherIMG = [UIImage imageNamed:@"snow-100.png"];
                break;
            case 5:
                  weatherIMG = [UIImage imageNamed:@"clouds-100.png"];
                break;
            case 6:
                  weatherIMG = [UIImage imageNamed:@"sleet-100.png"];
                break;

        }
        
        [item.TerminalLabel setNumberOfLines:0];
        [item.TerminalLabel setText:@"Terminal - Gate: "];
 
    
        [item.WeatherValue setText:weather];
        [item.WeatherValue setHidden:YES];
    
        [item.TempValue setText:temp];
        [item.TempValue setHidden:YES];
        
        [item.imageView setImage:randomImg];
        [item configureImageAndBorderView];
        
        [item setTitle:@"Flight Detail"];
        
        [item setFoodType:Flight];
        
        [item.Arrival_DepartureValue setText:time];
        [item.Arrival_DepartureValue setHidden:YES];
        
        [item.AircraftValue setText:aircraft];
        
        UIImage *arr_depImg = nil,
                       *tempIMG     = [UIImage imageNamed:@"temperature-100.png"],
                       *airlineIMG   =  selectedCell.imageView.image;
    
        if (tempHId > 50){
            tempIMG =   [UIImage imageNamed:@"temperature_filled-100.png"];
        }
        NSString *fligthDetail = @"";
        switch (indexPath.section){
                //Arrivals
 
            case 0:
                arr_depImg = [UIImage imageNamed:@"airplane_land-100.png"];
                status = instArr;
                [item.AircraftLabel setText:@"Baggage Claim: "];

                [item.AircraftValue setText:@"To Be Announced"];

                if ([status isEqualToString:@"Luggage Being Loaded to Baggage Belt"] || [status isEqualToString:@"Landed"]){
                    fligthDetail = [flight stringByReplacingOccurrencesOfString:@"Arriving" withString:@"Arrived"];
 
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",fligthDetail,time];
 
                }else{
 
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",flight,time];
 
                    fligthDetail = [fligthDetail  stringByReplacingOccurrencesOfString:@"Arriving from" withString:@"Scheduled to Arrive From"];
                }
                
                [item.FlightLabel setText:@"Arrival Details:"];
                [item.FlightValue setText:fligthDetail];
                
//                [item.AircraftLabel setText:@"Weather \nConditions:"];
   //             [item.AircraftValue setText:[NSString stringWithFormat:@"%@ - (%@)",weather,temp]];
                
   
                if ([status isEqualToString:@"Luggage Being Loaded to Baggage Belt"] || [status isEqualToString:@"Landed"]){
                    NSInteger iC = arc4random_uniform(13);
                    if (iC == 0){
                        iC = 1;
                    }
                    [item.AircraftValue setText:[NSString stringWithFormat:@"Carousel #%d",iC]];
                }
                break;
                //Departures
            case 1:
                
                arr_depImg = [UIImage imageNamed:@"airplane_takeoff-100.png"];
                status = instDept;
                
                if ([status isEqualToString:@"Departed"] || [status isEqualToString:@"Taxiing"]){
                    fligthDetail = [flight stringByReplacingOccurrencesOfString:@"Departing" withString:@"Departed"];
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",fligthDetail,time];
                }else{
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",flight,time];
                    fligthDetail = [fligthDetail  stringByReplacingOccurrencesOfString:@"Departing to" withString:@"Scheduled To Depart To"];
                }
                [item.FlightLabel setText:@"Departure Details:"];
                [item.FlightValue setText:fligthDetail];
                break;
        }
        
        randomImg  = [UIImage imageNamed:randomImgName];
        
        if (appDelegate.isiPhone){
            [item.AircraftValue setText:[NSString stringWithFormat:@"\n%@",item.AircraftValue.text]];
            [item.FlightValue setNumberOfLines:0];
            if (item.FlightValue.text.length > 40){
            [item.FlightValue  setFont:[UIFont systemFontOfSize:11.5f]];
            }else{
            [item.FlightValue  setFont:[UIFont systemFontOfSize:15.0f]];
            }
        }
        
        NSArray *titleData = [gate componentsSeparatedByString:@"| Flight# "];
        NSString *gateFinal = [titleData firstObject];
        
        if (titleData){
            instructions  = [NSString stringWithFormat:@"Flight %@", [titleData lastObject]];
            [item.TerminalValue setNumberOfLines:0];
            if (appDelegate.isiPhone){
                gateFinal = [gateFinal stringByReplacingOccurrencesOfString:@"-" withString:@"-\n"];
            }
            [item.TerminalValue setText:gateFinal];
        }
        
        [item.TempIMGView setImage:tempIMG];
        [item.TempIMGView setHidden:YES];
        
        [item.ArrDepIMGView setImage:arr_depImg];
        [item.ArrDepIMGView setHidden:YES];
        
        [item.AirlineIMGView setImage:airlineIMG];
   /*     [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor darkGrayColor];
       [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];*/
        
   
        [item.weatherIMGView setImage:weatherIMG];
        [item.weatherIMGView setHidden:YES];

        [item.instructionsLabel setText:instructions];
        [item.StatusValue setText:status];
    }];
    
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 2  ;
    /*
      1- Arrivals
      2- Departures
     */
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (section) {
     case 0:
            rowCount = 9 ;
     break;
        case 1:
            rowCount = 9;
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
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Arriving/Departing Flights"]];
    // Do any additional setup after loading the view.
    //[self roundLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
