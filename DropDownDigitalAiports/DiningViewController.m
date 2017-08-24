//
//  AppetizersViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/20/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "DiningViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"

@interface DiningViewController(){
    
    AppDelegate *appDelegate;
    
    UIImageView *selectedImageView;
    
    NSString *selectedRestaurant ;
    
    NSArray *restaurants ,
            *toGo,
            *foodCourt,
            *shops,
            *gifts;

}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation DiningViewController


- (void)imageUpdated:(NSNotification *)notif {
    
 
   /* NSDictionary *modelData = nil;
    NSIndexPath *indexPath = (NSIndexPath *) [notif object];
    
    if (indexPath){
    
        if (indexPath ){
            
            if (model.imageData){
                //   NSLog(@"Reloading index path to display image %@", model.imageUrl);
                
                @try {
                    [self.tableView beginUpdates];
                    
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView endUpdates];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Reloading index Path Image = %@",exception.description);
                }
                @finally {
                    model = nil;
                }
            }
            
        }
    }*/
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
        
        if (! appDelegate){
            appDelegate = [AppDelegate currentDelegate];
        }
        
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
             appsCount        = 0,
             itemsCount       = 0;
    
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
                        if (appDelegate.appItems){
                            appsCount = [[appDelegate.appItems objectForKey:@"Quantity"] integerValue];
                            
                            [self initiateAddToCart:appsCount];
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


-(void) initTableView{
    
    NSString *message = @"";
    
    @try{
        
        if (! restaurants){
          /*  restaurants = [[NSArray alloc] initWithObjects:@"Andaluca", @"Orsay",@"Terra Bistro", @"Carbone Ristorante Italiano",
                           @"Chart House",@"SkyLine Terrace",@"BRIO",
                           @"Tapastre",@"Cafe Prague",nil];*/
            
            restaurants = [[NSArray alloc] initWithObjects:@"Andaluca" ,@"BRIO", @"Cafe Prague",@"Carbone Ristorante Italiano",@"Chart House",
                                                           @"Orsay",@"SkyLine Terrace", @"Tapastre",@"Terra Bistro",nil];
        }
        
        if (! toGo){
            toGo= [[NSArray alloc] initWithObjects:@"Arby's", @"Ben & Jerry's", @"Chipotle",@"Dunkin' Donuts",@"Moe's",
                                                   @"Peet's Coffee & Tea",@"StarBucks",@"Tijuana Flats",@"Wendy's",nil];
        }
        
        if (! foodCourt){
            foodCourt = [[NSArray alloc] initWithObjects:@"Au Bon Pain",@"Burger King", @"Curry Kitchen",@"KFC",
                                                         @"Mc Donald's",@"SBarro",@"Subway",@"Taco Bell",@"Wok Box",nil];
        }
        
        if (! shops){
            shops = [[NSArray alloc] initWithObjects: @"Burberry",@"Chanel",@"Coach", @"Emporio Armani",
                                                      @"Gucci", @"LongChamp",@"Louis Vuitton", @"Michael Kors",  @"Prada", nil];
            
        }
        
        if (! gifts){
            gifts = [[NSArray alloc] initWithObjects: @"Chocolate La Maison - Chocolates",@"Hudson News - News & Events",@"La Relay - Magazines",
                                                      @"Loccitane - Skin Care",@"Le Brookstone - Gadgets", @"News CNBC - Smart Shop", nil];
            
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
    
    NSInteger calories =  arc4random_uniform(400);
    
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
            [header setText:@"Fine Dining"];
            break;
        case 1:
            [header setText:@"Meals to Go"];
            break;
        case 2:
            [header setText:@"The Food Court"];
            break;
        case 3:
            [header setText:@"Shopping"];
            break;
        case 4:
            [header setText:@"Concessions & Gift Stores"];
            
    }
    return header;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger sectionId = -1;
    
    switch (section) {
        case 0:
            sectionId = restaurants.count;
            break;
        case 1:
            sectionId = toGo.count;
            break;
        case 2:
            sectionId = foodCourt.count;
            break;
        case 3:
            sectionId = shops.count;
            break;
        case 4:
            sectionId = gifts.count;
            break;
    }
    return  sectionId;
}

-(NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cellDining",
                    *restaurantName = @"",
                    *locationFormat = @"Located in Terminal %@ - Near to Gate %d" ,
                    *restaurantImageNameFormat = @"AirportDining_%d.jpg",
                    *restaurantImageName = @"",
                    *terminal = @"",
                    *cuisine = @"",
                    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"N", @"C",  @"S", nil],
    
                    *cuisines = [[NSArray alloc] initWithObjects: @"Mexican", @"American", @"Thai",
                                                                  @"Italian",@"French", @"Sushi",@"Irish",
                                                                  @"Spanish", @"American",nil],
    
                    *toGos = [[NSArray alloc] initWithObjects: @"Burgers & Fries", @"Ice Cream", @"Tacos",
                                                               @"Donuts",@"Burritos", @"Coffee & Tea",@"Coffee",
                                                               @"Chimichangas", @"Burgers & Fries",nil],

    
                    *courts = [[NSArray alloc] initWithObjects: @"French Bakery", @"American Food", @"Indian Food",
                                                                @"Southern Cooking",@"American Food", @"NY Style Pizza",@"Sandwiches",
                                                                @"Mexican Food", @"Chinese Food",nil];
    
    
    NSInteger terminalId = arc4random_uniform(Terminals.count),
              gateId = arc4random_uniform(50),
              imageId = 1;
    
    BOOL isParse = NO;
    
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
    
    
    switch (indexPath.section) {
        case 0:
                restaurantImageNameFormat = @"AirportDining_%d.jpg",
                restaurantName = [restaurants objectAtIndex:indexPath.row];
                cuisine = [cuisines objectAtIndex:indexPath.row];
                isParse = YES;
            
            if (isParse) {
                
                [Utilities setParseImageCell:appDelegate.diningbackgrounds anyIndex:indexPath.row tableCell:cell];
                
            }
            break;
        case 1:
                restaurantImageNameFormat = @"ToGo_%d.jpg",
                restaurantName = [toGo objectAtIndex:indexPath.row];
               cuisine = [toGos objectAtIndex:indexPath.row];
            
            isParse = YES;
            
            if (isParse) {
                
                
           [Utilities setParseImageCell:appDelegate.foodtogobackgrounds anyIndex:indexPath.row tableCell:cell];
            }
            
            break;
            
        case 2:
                restaurantImageNameFormat = @"FoodCourt_%d.jpg",
                restaurantName = [foodCourt objectAtIndex:indexPath.row];
                cuisine = [courts objectAtIndex:indexPath.row];
            
            isParse = YES;
            
            if (isParse) {
            
                [Utilities setParseImageCell:appDelegate.foodcourtbackgrounds anyIndex:indexPath.row tableCell:cell];
            }
            break;
        case 3:
            
            restaurantName = [shops objectAtIndex:indexPath.row];
            isParse = YES;
            
            if (isParse) {
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.shopsbackgrounds anyIndex:indexPath.row];
                
                [cell.imageView setImage:cellImage];
            }
            
            break;
        case 4:
            restaurantImageNameFormat = @"GiftStore_%d.jpg";
            restaurantName = [gifts objectAtIndex:indexPath.row];
            break;
    }
   restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,imageId];
    
    terminal = [NSString stringWithFormat:@"%@",terminal];
    finalLocation = [NSString stringWithFormat:locationFormat, terminal,gateId];
    if (indexPath.section < 3){
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@",restaurantName,cuisine]];
    }
    else{
        [cell.textLabel setText:restaurantName];
    }
    [cell.detailTextLabel setText:finalLocation];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryView.tintColor = [UIColor whiteColor];
    
        if (! isParse){
            [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
        }
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *message                   = @"",
             *restaurantImageNameFormat = @"",
             *restaurantImageName       = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;

            switch (indexPath.section) {
                case 0:
                    
                    [Utilities setParseImageCell:appDelegate.diningbackgrounds anyIndex:indexPath.row tableCell:cell];
                    break;
                    
                case 1:
                    [Utilities setParseImageCell:appDelegate.foodtogobackgrounds anyIndex:indexPath.row tableCell:cell];
                    break;
                
                case 2:
                    [Utilities setParseImageCell:appDelegate.foodcourtbackgrounds anyIndex:indexPath.row tableCell:cell];
                    break;
                case 3:
                      [Utilities setParseImageCell:appDelegate.shopsbackgrounds anyIndex:indexPath.row tableCell:cell];
                    break;
                    
                case 4:
                    
                     restaurantImageNameFormat = @"GiftStore_%d.jpg",
                     restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,indexPath.row];
                     [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
                    break;
            }
            
            UIImage *cellImage = nil;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90, 45)];
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
    [item setFoodType:Dining];
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
        
        NSString *rndFoodImgFormat       = @"Food_%d.png",
                 *rndFoodImgFormatToo    = @"AirportShops_X_%d.jpg",
                 *rndFoodImgName         = @"";
        
        NSInteger rndFoodImgId = arc4random_uniform(13);
        
  
        
        if (rndFoodImgId == 0){
            rndFoodImgId = 1;
        }
        
        UIImage *randomImg = image;
        [item.imageView setImage:randomImg];
 
        [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor colorWithHexString:@"f0f0f0"];
        [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
        
        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];
       
        [item.weatherIMGView setImage:[UIImage imageNamed:@"food-100.png"]];
        [item.weatherIMGView setHidden:YES];
        
        [item.ArrDepIMGView setImage:[UIImage imageNamed:@"food-100.png"]];

     
        
        NSArray *cuisines = [[NSArray alloc] initWithObjects: @"American", @"Steakhouse", @"Chinese", @"Seafood",
                                                              @"Italian",@"Burgers and Fries",@"Latin", @"Thai",@"Mexican", nil],
                *prices    = [[NSArray alloc] initWithObjects:@"$", @"$$", @"$$$", @"$$$$", nil],
                *ratings   = [[NSArray alloc] initWithObjects:@"**", @"***", @"****", @"*****", nil],
                *toGoImgs  = [[NSArray alloc] initWithObjects:@"hamburger-100.png", @"ice_cream_cone-100.png", @"taco-100.png",
                                                              @"doughnut-100.png",@"wrap-100.png", @"tea-100.png",@"coffee_to_go-100.png",
                                                              @"wrap-100.png", @"french_fries-100.png",nil],
                *courtImgs = [[NSArray alloc] initWithObjects:@"bread-100.png", @"hamburger-100.png", @"chili_pepper-100.png",
                                                              @"cook-100.png",@"french_fries-100.png", @"pizza-100.png",@"hot_dog-100.png",
                                                              @"taco-100.png", @"noodles-100.png",nil];
        
        
        
        NSArray *shopsTypes = [[NSArray alloc] initWithObjects:@"Fashionable Accessories\n & Clothing", @"Fragrances",
                             @"Fashionable Accessories\n & Clothing", @"Menswear",
                             @"Fashionable Accessories\n & Clothing" , @"Luxury Leather\n Accessories",
                             @"Fashionable Accessories", @"Women’s Accessories", @"Designer Fashion",  nil],
        
                *shopImages = [[NSArray alloc] initWithObjects:@"coat-50.png", @"perfume_bottle-100.png", @"wallet_filled-50.png",
                             @"jacket-100.png",@"glasses_filled-50.png" ,@"shopping_bag-100.png",
                             @"womens_shoe-100.png",@"shopping_bag_filled-100.png", @"market_square_filled-100.png",nil],
        
        *clothes = [[NSArray alloc] initWithObjects:@"Neck Ties", @"Jackets", @"T-Shirts", @"Trousers", @"Hats" , nil],
        
        *clothesImages = [[NSArray alloc] initWithObjects:@"tie_filled-100.png",@"jacket-100.png", @"t_shirt-100.png",
                          @"trousers-100.png",@"baseball_cap-100.png",nil],
        
        *skin = [[NSArray alloc] initWithObjects:@"Make Up", @"Moisturizers", @"Beauty", @"Perfumes",  nil],
        
        *skinImages = [[NSArray alloc] initWithObjects:@"costmetic_brush-100.png" @"cream_tube-100.png",
                       @"mirror-100.png",@"perfum_bottle_filled-100.png",nil],
        
        *giftTypes =[[NSArray alloc] initWithObjects:@"Chocolates", @"News & Events", @"Magazines",@"Skin Care" ,@"Gadgets", @"Smart Shop",nil],
        
        *giftImages = [[NSArray alloc] initWithObjects:@"macaron-100.png", @"news-100.png", @"news-100.png",
                       @"cosmetic_brush-100.png" ,@"electro_devices_filled-100.png",@"idea-100.png",nil];
        
       // *ratings  = [[NSArray alloc] initWithObjects:@"Online Pay", @"InStore Pay", nil];
        
        
        NSInteger cuisineId  = arc4random_uniform(cuisines.count),
                  shopsid    = arc4random_uniform(shops.count),
                  clothesid  = arc4random_uniform(clothes.count),
                  priceId    = arc4random_uniform(prices.count),
                  giftid     = arc4random_uniform(giftTypes.count),
                  rateId     = arc4random_uniform(ratings.count);
        
        NSString *cuisine = [cuisines objectAtIndex:cuisineId],
                 *clothe  = [clothes objectAtIndex:clothesid],
                 *gift    = [giftTypes objectAtIndex:giftid],
                 *price   = [prices objectAtIndex:priceId],
                 *rating  = [ratings objectAtIndex:rateId],
                 *shop    = [shops objectAtIndex:shopsid],
                 *hours   = @"Monday to Sunday 10 AM - 9 PM",
                 *site    = @"";
    
        [item.WeatherValue setText:cuisine];
        [item.WeatherValue setHidden:YES];
        
        
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
            
            if (indexPath.section < 3){
              [btnReserve addTarget:self action:@selector(actionReserveClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
              [btnReserve addTarget:self action:@selector(actionShopReserveClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            [item.TempIMGView setHidden:YES];
            [item.view addSubview:btnReserve];
            [item.view bringSubviewToFront:btnReserve];
            
        }

    
        [item.FlightLabel setText:@"Hours: "];
        
        [item.FlightValue setText:hours];
        
        [item.TerminalValue setText: [desc stringByReplacingOccurrencesOfString:@"Located in " withString:@""]];
        
        NSArray *titleData = [title componentsSeparatedByString:@"-"];
        
        NSString *Newtitle = title,
                 *NewType = cuisine,
                 *NewSite = title,
                 *phone    = [ItemViewController generateRandomPhone],
                 *shopTypeImageName  = @"";
    
        if (titleData){
           Newtitle = [titleData firstObject];
            selectedRestaurant = [Newtitle substringToIndex:Newtitle.length - 1];
           NewType = [titleData lastObject];
           NewSite =  [NSString stringWithFormat:@"www.%@.com",
                        [Newtitle stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        }
        [item.instructionsLabel setText:Newtitle];
        [item.Arrival_DepartureValue setText:NewType];
        [item.StatusLabel setText:@"Phone: "];
        
        item.TerminalValue.text =  [NSString stringWithFormat:@"\n%@",item.TerminalValue.text];
        if (appDelegate.isiPhone){

            switch (appDelegate.screenHeight) {
                case 736:
                    //tread as ipad
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
        [item.AircraftValue setText:[NewSite stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        rndFoodImgFormat = @"Food_%d.png";
        
        NSInteger t = 1;
        rndFoodImgFormat = [rndFoodImgFormat stringByReplacingOccurrencesOfString:@"Food" withString:NewType];
        rndFoodImgFormat =  [rndFoodImgFormat stringByReplacingOccurrencesOfString:@" " withString:@""];
 
        UIImage *nImage = nil;
        
        CGSize newSize = CGSizeMake(100, 100);
        
        BOOL NeedsImage = YES;
        
        switch (indexPath.section) {

            case 0:
                switch (indexPath.row) {
                    case 5:
                        t = 4;
                        [item.ArrDepIMGView setImage:[UIImage imageNamed:@"sushi_filled-100.png"]];
                        break;
                    case 1:
                    case 8:
                        t = 3;
                        break;
                    case 0: 
                    case 3:
                    case 4:
                    case 6:
                    case 7:
                    case 2:    
                        t = 4;
                        break;

                }
                    [item startTimer: rndFoodImgFormat : t];
            break;
            case 1:
                    [item.ArrDepIMGView setImage:[UIImage imageNamed:[toGoImgs objectAtIndex:indexPath.row]]];

                switch (indexPath.row) {
                    case 0:
                        t = 4;
                        break;
                    case 1:
                        t = 3;
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                        t = 5;
                        break;
                    case 4:
                    case 7:
                        t = 4;
                        break;
                    case 8:
                        t = 6;
                        rndFoodImgFormat = @"Wendy_%d.png";
                        break;
                }
                [item startTimer: rndFoodImgFormat : t];
            
            break;
            case 2:
                   [item.ArrDepIMGView setImage:[UIImage imageNamed:[courtImgs objectAtIndex:indexPath.row]]];

                switch (indexPath.row) {
                    case 0:
                    case 6:
                    case 3:
                        t = 4;
                        break;
                    case 1:
                    case 4:
                        t = 2;
                        break;
                    case 2:
                    case 5:
                    case 8:
                        t = 5;
                        break;
                    case 7:
                        t = 3;
                        break;
                }
                [item startTimer: rndFoodImgFormat : t];
                
            break;
            case 3:
                shopsid = indexPath.row;
                shop =   [shopsTypes objectAtIndex:shopsid];
                [item.Arrival_DepartureValue setText:shop];
                shopTypeImageName = [shopImages objectAtIndex:shopsid];
                rndFoodImgId = shopsid;
                rndFoodImgFormat          = @"AirportShops_%d_%d.jpg";
                rndFoodImgName =  [Utilities getParseColumnValue:appDelegate.shopsbackgrounds anyIndex:shopsid anyColumn:@"ImageURL"];//[NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                 nImage = [UIImage imageNamed:shopTypeImageName];
                 newSize = CGSizeMake(100, 100);
                
                [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
                [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
                [item.AirlineIMGView.layer setBorderWidth:1.0f];
                
                [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
                
                if ([clothe length] > 18 && indexPath.section == 3){
                    newSize = CGSizeMake(60, 60);
                    [item.Arrival_DepartureValue setFont:[UIFont fontWithName:@"Avenir Next" size:15.0f]];
                }
                
                nImage = [ItemViewController imageResize:nImage andResizeTo:newSize];
                [item.ArrDepIMGView setImage:nImage];
                
                
                rndFoodImgFormatToo  = [rndFoodImgFormatToo stringByReplacingOccurrencesOfString:@"X"
                                                                                      withString:[NSString stringWithFormat:@"%d",indexPath.row]];
                
                clothes = skin;
                clothesImages = skinImages;
                

 
                NeedsImage = NO;
                
                t = 5;
                [item startTimer:rndFoodImgFormatToo :t];
                

                
            break;
            case 4:
                giftid = indexPath.row;
                
                gift =  [giftTypes objectAtIndex:giftid],
                [item.Arrival_DepartureValue setText:gift];
                shopTypeImageName = [giftImages objectAtIndex:giftid];
                rndFoodImgName =[NSString stringWithFormat:@"%@_%d.jpg", [gift stringByReplacingOccurrencesOfString:@" " withString:@""], giftid];
                
                [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
                [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
                [item.AirlineIMGView.layer setBorderWidth:1.0f];
                
                [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
                
                nImage = [UIImage imageNamed:shopTypeImageName];
                newSize = CGSizeMake(100, 100);
                
 
                nImage = [ItemViewController imageResize:nImage andResizeTo:newSize];
                [item.ArrDepIMGView setImage:nImage];
                
                NeedsImage = NO;
                
                switch (indexPath.row) {
                    case 0:
                        rndFoodImgFormat = @"Chocolates_%d.jpg";
                        t = 4;
                        break;
                    case 1:
                        rndFoodImgFormat = @"News&Events_%d.jpg";
                        t = 4;
                        break;
                    case 2:
                        rndFoodImgFormat = @"Magazines_%d.jpg";
                        t = 4;
                        break;
                    case 3:
                        rndFoodImgFormat = @"SkinCare_%d.jpg";
                        t = 4;
                        break;
                    case 4:
                        rndFoodImgFormat = @"Gadgets_%d.jpg";
                        t = 4;
                        break;
                    case 5:
                        rndFoodImgFormat = @"SmartShop_%d.jpg";
                        t = 4;
                        break;
                }
                [item startTimer:rndFoodImgFormat :t];
                
                break;
        }
        
        if (NeedsImage){
            rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,1];
            [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
        }
 

    }];
}

- (IBAction)actionShopReserveClicked:(UIButton *)sender {
    NSURL  *url= nil;
    
    NSString *currentName = @"",
    *message= @"",
    *launchURL = @"";
    
    @try {
        
        currentName = selectedRestaurant;
        if ([currentName length] > 0){
            currentName = [currentName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSLog(@"Invoking OMPN for %@",currentName);
        }
        
        launchURL = [NSString stringWithFormat:@"%@?term=%@",kOMPNApp,currentName];
        
        
        message = [NSString stringWithFormat:@"Airport:Shops:ROP->%@",launchURL];
        
        [MSAnalytics trackEvent:message];
        
        url=  [[NSURL alloc] initWithString:launchURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            message = [NSString stringWithFormat:@"Launching OMPN App-> %@",url];
        }else{
            url=  [[NSURL alloc] initWithString:kOMPN];
            message = [NSString stringWithFormat:@"Launching OMPN Web-> %@",url];
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



- (IBAction)actionReserveClicked:(UIButton *)sender {
    NSURL  *url= nil;
    
    NSString *currentName = @"",
                    *message= @"",
                    *launchURL = @"";
    
    @try {
        
        currentName = selectedRestaurant;
        if ([currentName length] > 0){
            currentName = [currentName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        }
        
        launchURL = [NSString stringWithFormat:@"%@?name=%@",kOMTNApp,currentName];
        
        message = [NSString stringWithFormat:@"Airport:Dining:ROP->%@",launchURL];
        
        [MSAnalytics trackEvent:message];
        
        url=  [[NSURL alloc] initWithString:launchURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            message = [NSString stringWithFormat:@"Launching OMTN App-> %@",url];
        }else{
            url=  [[NSURL alloc] initWithString:kOMTN];
            message = [NSString stringWithFormat:@"Launching OMTN Web-> %@",url];
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
    NSInteger fontSize = kTitleSize;
    @try {
        
        if (appDelegate.isiPhone){
            
            switch (appDelegate.screenHeight) {
                case 736:
                    //tread as ipad
                    break;
                    
                default:
                        fontSize = kTitleIPhoneSize;
                    break;
            }
            
     
        }
        
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:@"Avenir Roman" size:fontSize]];
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

-(void) unRegisterImageDowloadNotification{
    // At end of viewDidUnLoad
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kImageDownloadDiningNotifications
                                                  object:nil];
}

-(void) registerImageDowloadNotification{
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kImageDownloadDiningNotifications
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
                                                          
                                                          [self imageUpdated:note];
                                                          
                                                      }];
    
    
    
}


-(void) viewDidLoad{
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initTableView];
    
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Fine Dining/Meals To Go/The Food Court"]];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self unRegisterImageDowloadNotification];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkOrderCount];
    [self registerImageDowloadNotification];
}

@end
