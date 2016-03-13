//
//  MeatDetailViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/10/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//
#import "AppDelegate.h"
#import "GroundTransportationViewController.h"
#import "ItemViewController.h"
#import "Constants.h"
#import "CarRentalsViewController.h"

@interface GroundTransportationViewController()
{
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation GroundTransportationViewController


#pragma -mark Cart Animation

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


-(void)checkOrderCount{
    
    NSString *message   = @"",
             *orderItem = @"";
    
    NSInteger orderItems        = 0,
              currentOrderCount = 0,
              entCount          = 0,
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
                
                if (selectedImageView != nil){
                    
                    if (appDelegate.entreeItems){
                        
                        entCount = [[appDelegate.entreeItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:entCount];

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
    
    NSInteger calories =  arc4random_uniform(450);
    
    cal = [NSString stringWithFormat:cal,calories];

    return cal;
    
}



-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    
    NSString *cellID = @"cellShopping",
                    *transportationName = @"",
                    *locationFormat = @"Located outside most terminals and parking areas throughout the airport" ,
                    *restaurantImageNameFormat = @"AirportShops_%d.jpg",
                    *restaurantImageName = @"",
                    *terminal = @"",
                    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"H", @"T", nil];
    
    NSInteger terminalId = arc4random_uniform(Terminals.count),
                        gateId = arc4random_uniform(50),
                        imageId = 0;
    
    
    if (gateId == 0){
        gateId = 1;
    }
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            
            terminal = [Terminals objectAtIndex:terminalId];
            
            restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,imageId];
            
            terminal = [NSString stringWithFormat:@"%@",terminal];
            
            switch (indexPath.row) {
                case 0:
                    locationFormat = @"Located outside most terminals and at various locations throughout the city.";
                    break;
                case 1:
                    locationFormat = @"Located inside most airport terminals, parking garages and at various locations throughout the city.";
                    break;
                case 2:
                    locationFormat = @"Located outside each terminal.\nShuttles leave every 15 minutes.";
                    break;
                case 5:
                    locationFormat = @"Located outside each terminal.\nFor all Metropolitan Atlanta Rapid Transit Authority (MARTA) schedules, please refer to www.MARTA.com.";
                    break;
                case 3:
                   locationFormat = @"Conveniently located outside of most terminals.\nShuttles leave every 15 minutes.\nWe can be reached at (619) 393-2930.";
                    break;
                default:
                    break;
            }
            
            finalLocation = locationFormat;
            
            [cell.detailTextLabel setText:finalLocation];
            [Utilities setParseImageCell:appDelegate.groundbackgrounds anyIndex:indexPath.row tableCell:cell];
            
            UIImage *cellImage =  cell.imageView.image;
            
            if (! cellImage){
              cellImage =   [UIImage imageNamed:@"PlaceHolder.png"];
            }
            
            if (appDelegate.isiPhone){
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90, 45)];
                }
             /*   [cell.imageView setImage:cellImage];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedIP = [self.tableView indexPathForSelectedRow];
    
    CarRentalsViewController *destVC = (CarRentalsViewController*) [segue destinationViewController];
    
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return;
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
    

    if ( selectedCell.imageView){
        selectedImageView =  selectedCell.imageView;
    }
    
    
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {
        
        CGRect imageRect = CGRectMake(0.0f, 60.0f, 600,600);
        
        [item.imageView setFrame:imageRect];
        [item.imageView setImage:image];
        [item setFoodType:Terminal];
        
        switch (indexPath.section) {
            /*case 0:
                [item setEntreeType:Beef];
                break;*/
            case 1:
            //    [item setEntreeType:Chicken];
                break;
            case 2:
         //       [item setEntreeType:Seafood];
                break;
            case 0:
          //      [item setEntreeType:Pasta];
                break;
        }
        
        [item configureSegs];

        [item.FlightValue setText:title];
        [item.labelDescription setText:desc];
        
        
    }];
    
    
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1;//4 /*Make 4 to include beef*/
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 1;
    
    switch (section) {
        case 0:
            rowCount = 6;
            break;
        /* case 1:
            rowCount = 5;
            break;
        case 2:
            rowCount = 5;
            break;
       case 0:
            rowCount = 4;
            break;*/
    }
    return rowCount;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    
    
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Ground Transportation"]];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkOrderCount];
}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 70.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        //[titleView setFont:[UIFont fontWithName:@"Avenir Medium" size:22.0f]];
        [titleView setFont:[UIFont systemFontOfSize:20.0f]];
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
