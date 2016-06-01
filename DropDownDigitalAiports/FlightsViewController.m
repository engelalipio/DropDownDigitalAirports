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
#import "DataModels.h"

@interface FlightsViewController ()
{
    NSMutableArray *menuTitles,
                                *arrivals,
                                *departures;
    
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
    
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation FlightsViewController
@synthesize AirLineName = _AirLineName;
@synthesize AirLineLogoURL = _AirLineLogoURL;

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
        alignment = NSTextAlignmentCenter;
    }
    switch (section) {
        case 0:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setText:[NSString stringWithFormat:@"%lu Arrival Time(s)",(unsigned long)arrivals.count]];
            break;

        case 1:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextColor:[UIColor whiteColor]];
            [header setTextAlignment:alignment];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setText:[NSString stringWithFormat:@"%lu Departure Time(s)",(unsigned long)departures.count]];
            break;
    }
    return header;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    FidsData *fidsData = [[FidsData alloc] init];
    
    //airlineName,airlineLogoUrlPng,flightNumber,city,currentTime,gate,terminal,baggage,remarks,weather,destinationFamiliarName"
    
    NSString *cellID = @"cbFlights",
                    *airlineName = @"",
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

    
    switch (indexPath.section) {
        case 0:
            fidsData = [FidsData objectFromJSONObject:[arrivals objectAtIndex:indexPath.row]  mapping:[fidsData dictionaryRepresentation]];
              destinationFamiliarName = [NSString stringWithFormat:@"Arriving from %@ at %@", [fidsData city],[fidsData currentTime]];
            break;
            
        case 1:
            fidsData = [FidsData objectFromJSONObject:[departures objectAtIndex:indexPath.row]  mapping:[fidsData dictionaryRepresentation]];
            destinationFamiliarName = [NSString stringWithFormat:@"Departing to %@ at %@", [fidsData city],[fidsData currentTime]];
            break;
    }
    
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
 

    finalLocation = [NSString stringWithFormat:@"Terminal %@ - Gate %@ | Flight# %@",terminal,gate,flightNumber];
    
   
    [cell.textLabel setText:destinationFamiliarName];
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
    
    int imgIdx =  arc4random_uniform(appDelegate.flightbackgrounds.count);
    
    UIImage *image = [Utilities getParseImage:appDelegate.flightbackgrounds anyIndex:imgIdx];
    
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
    }else{
        [selectedCell.imageView setImage: image];
    }
    
   
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {

        UIImage *randomImg = image,
                       *weatherIMG = nil;
    
    
        NSArray *weatherData = [[NSArray alloc] initWithObjects:@"Sunny", @"Rainy", @"Windy", @"Overcast",@"Cloudy", @"Snow",  @"Sleet", nil],
        
                        *instArrData = [[NSArray alloc] initWithObjects:@"Luggage Being Loaded to Baggage Belt", @"Landed", @"Delayed", nil],
        
                        *instDepData = [[NSArray alloc] initWithObjects:@"Departed", @"Gate Closing", @"Boarding",  @"Taxiing", nil],
        
                        *statusData = [[NSArray alloc] initWithObjects:@"On Schedule", @"Delayed", @"Maintenance Check", @"Restocking Aircraft",  nil],
        
                        *planeData = [[NSArray alloc] initWithObjects:@"Boeing 737 AirBus", @"Boeing 747-8",@"Boeing 727 AirMax",
                                                                                                    @"Boeing 777-X", @"Boeing 777 AirBus",  nil];
       
        NSInteger imageId =  arc4random_uniform(weatherData.count - 2),
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
                weatherIMG = [UIImage imageNamed:@"clouds-100.png"];
                    break;
            case 5:
                weatherIMG = [UIImage imageNamed:@"snow-100.png"];
                break;
            case 6:
                  weatherIMG = [UIImage imageNamed:@"sleet-100.png"];
                break;

        }
        
        [item.TerminalLabel setNumberOfLines:0];
        [item.TerminalLabel setText:@"Terminal/Gate: "];
 
    
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
        

        
        UIImage *arr_depImg = nil,
                       *tempIMG     = [UIImage imageNamed:@"temperature-100.png"],
                       *airlineIMG   =  selectedCell.imageView.image;
        
        airlineIMG = [Utilities imageResize:airlineIMG andResizeTo:CGSizeMake(300.0f, 100.0f)];
    
        if (tempHId > 50){
            tempIMG =   [UIImage imageNamed:@"temperature_filled-100.png"];
        }
        NSString *fligthDetail = @"";
        BOOL isDeparture = NO;
        
        FidsData *fidsData = [[FidsData alloc] init];
       
        
        switch (indexPath.section){
                //Arrivals
 
            case 0:
               fidsData = [FidsData objectFromJSONObject:[arrivals objectAtIndex:indexPath.row]  mapping:[fidsData dictionaryRepresentation]];
                arr_depImg = [UIImage imageNamed:@"airplane_land-100.png"];
                status = [fidsData remarksCode];
                [item.AircraftLabel setText:@"Baggage Claim: "];

                instArr =fidsData.baggage;
                if (! instArr){
                    instArr = @"tbd";
                }
                
                [item.AircraftValue setText:[NSString stringWithFormat:@"Carousel #%@", instArr]];

                fligthDetail = flight;
                /*if ([status isEqualToString:@"Luggage Being Loaded to Baggage Belt"] || [status isEqualToString:@"Landed"]){
                    fligthDetail = [flight stringByReplacingOccurrencesOfString:@"Arriving" withString:@"Arrived"];
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",fligthDetail,time];
 
                }else{
 
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",flight,time];
 
                    fligthDetail = [fligthDetail  stringByReplacingOccurrencesOfString:@"Arriving from" withString:@"Scheduled to Arrive From"];
                }*/
               
                
                [item.FlightLabel setText:@"Arrival Details:"];
                [item.FlightValue setText:fligthDetail];
                
                if ([status isEqualToString:@"Luggage Being Loaded to Baggage Belt"] || [status isEqualToString:@"Landed"]){
                    NSInteger iC = arc4random_uniform(13);
                    if (iC == 0){
                        iC = 1;
                    }
                    [item.AircraftValue setText:[NSString stringWithFormat:@"Carousel #%ld",(long)iC]];
                }
                break;
                //Departures
            case 1:
                fidsData = [FidsData objectFromJSONObject:[departures objectAtIndex:indexPath.row]  mapping:[fidsData dictionaryRepresentation]];
                isDeparture = YES;
                arr_depImg = [UIImage imageNamed:@"airplane_takeoff-100.png"];
                status = [fidsData remarks];
                fligthDetail = flight;
                /*if ([status isEqualToString:@"Departed"] || [status isEqualToString:@"Taxiing"]){
                    fligthDetail = [flight stringByReplacingOccurrencesOfString:@"Departing" withString:@"Departed"];
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",fligthDetail,time];
                }else{
                    fligthDetail = [NSString stringWithFormat:@"%@ at %@",flight,time];
                    fligthDetail = [fligthDetail  stringByReplacingOccurrencesOfString:@"Departing to" withString:@"Scheduled To Depart To"];
                }*/
                [item.FlightLabel setText:@"Departure Details:"];
                [item.FlightValue setText:fligthDetail];
                [item.AircraftLabel setText:@"Baggage Claim: "];
                
                aircraft = weather;
                
                if (fidsData.weather){
                    aircraft = weather;
                }
                
                [item.AircraftLabel setText:@"Weather: "];
                [item.AircraftValue setText:aircraft];
                break;
        }
        
        randomImg  = [UIImage imageNamed:randomImgName];

        if (appDelegate.isiPhone){
            if (isDeparture){
            //    item.FlightValue.text =   [NSString stringWithFormat:@"\n%@", item.FlightValue.text];
            }
            switch (appDelegate.screenHeight) {
                case 736:
                    //keep as ipad
                    
                  /*  if (![item.AircraftLabel.text  isEqual: @"Baggage Claim: "]){
                        [item.AircraftValue setText:[NSString stringWithFormat:@"%@\n",item.AircraftValue.text]];
                    }*/
                    
                    if (item.FlightLabel.text.length >= 18){

                      /*  [item.FlightLabel  setFont:[UIFont systemFontOfSize:14.0f]];
                        if(item.FlightValue.text.length <= 35){
                            item.FlightValue.text =   [NSString stringWithFormat:@"\n%@", item.FlightValue.text];
                        }
                    */
                    }
                    
                  if (item.FlightValue.text.length >= 43){
 
                      item.FlightLabel.text =   [NSString stringWithFormat:@"%@\n", item.FlightLabel.text];
                       //   item.FlightValue.text =   [NSString stringWithFormat:@"\n%@", item.FlightValue.text];
     
                      /*
                       
                        item.FlightLabel.text =   [item.FlightLabel.text stringByReplacingOccurrencesOfString:@"Departure Details:" withString:@"Departure\nDetails:"];
                        
                        [item.FlightValue  setFont:[UIFont systemFontOfSize:13.0f]];
                        if (item.FlightValue.text.length >= 40){
                            [item.FlightValue  setFont:[UIFont systemFontOfSize:12.0f]];
                        }*/
                    }
                    break;
                default:
                    [item.AircraftValue setText:[NSString stringWithFormat:@"\n%@",item.AircraftValue.text]];
                    [item.FlightValue setNumberOfLines:0];
                    if (item.FlightValue.text.length > 40){
                        [item.FlightValue  setFont:[UIFont systemFontOfSize:11.5f]];
                    }else{
                        [item.FlightValue  setFont:[UIFont systemFontOfSize:15.0f]];
                    }
                    break;
            }
        }
        

        
        NSArray *titleData = [gate componentsSeparatedByString:@"| Flight# "];
        NSString *gateFinal = [titleData firstObject];
        
        if (titleData){
            instructions  = [NSString stringWithFormat:@"Flight %@", [titleData lastObject]];
            [item.TerminalValue setNumberOfLines:0];
            if (appDelegate.isiPhone){
               // gateFinal =  [NSString stringWithFormat:@"\n%@",[titleData firstObject]];
                switch (appDelegate.screenHeight) {
                    case 736:
                        //keep as ipad
                        
                        if (status.length <= 20){
                            status = [NSString stringWithFormat:@"%@\n",status];
                        }
                        
                        break;
                        
                    default:
                            gateFinal = [gateFinal stringByReplacingOccurrencesOfString:@"-" withString:@"-\n"];
                        break;
                }
            

            }
            [item.TerminalValue setText:gateFinal];
        }
        
        [item.TempIMGView setImage:tempIMG];
        [item.TempIMGView setHidden:YES];
        
        [item.ArrDepIMGView setImage:arr_depImg];
        [item.ArrDepIMGView setHidden:YES];
        
        [item.AirlineIMGView setImage:airlineIMG];
        [item.AirlineIMGView setFrame:CGRectMake(self.view.frame.size.width/3 - 15.0f, item.AirlineIMGView.frame.origin.y,
                                                 item.AirlineIMGView.frame.size.width, item.AirlineIMGView.frame.size.height)];
   /*     [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor darkGrayColor];
       [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];*/
        
   
        [item.weatherIMGView setImage:weatherIMG];
        [item.weatherIMGView setHidden:YES];

        [item.instructionsLabel setText:instructions];
        
        status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        [item.StatusValue setText:[status capitalizedString]];
    }];
    
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 0  ;
    /*
      1- Arrivals
      2- Departures
     */
    
    if (arrivals.count > 0){
        sectionCount ++ ;
    }
    
    if (departures.count > 0){
        sectionCount++;
    }
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (section) {
     case 0:
            rowCount = arrivals.count ;
     break;
        case 1:
            rowCount = departures.count;
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
        arrivals = [appDelegate.arrivals objectForKey:@"Arrivals"];
        
        self.AirLineName = appDelegate.selectedAirlineName;
        
        if (arrivals){
            if (self.AirLineName){
                NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"airlineName like %@", self.AirLineName];
                if (predicate){
                    arrivals = [NSMutableArray arrayWithArray: [arrivals filteredArrayUsingPredicate:predicate]];
                }
            }
        }
        
    
        
        departures = [appDelegate.departures objectForKey:@"Departures"];
        if (departures){
            
            self.AirLineLogoURL = appDelegate.selectedAirlineLogo;
            
            if (self.AirLineLogoURL){
                 NSPredicate *dPredic = [NSPredicate predicateWithFormat:@"airlineLogoUrlPng like %@", self.AirLineLogoURL];
                
                if (dPredic){
                    departures = [NSMutableArray arrayWithArray: [departures filteredArrayUsingPredicate:dPredic]];
                }
            }
        }
        
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
