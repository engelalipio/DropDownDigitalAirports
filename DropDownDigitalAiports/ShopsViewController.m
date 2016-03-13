//
//  SoupsViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/20/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "ShopsViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"

@interface ShopsViewController() {
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
        NSArray *shops,
                        *gifts;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation ShopsViewController


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
              soupsCount        = 0,
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
                    if (appDelegate.soupItems){
                        soupsCount = [[appDelegate.soupItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:soupsCount];
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
        
        if (! shops){
            shops = [[NSArray alloc] initWithObjects: @"Burberry",@"Chanel",@"Coach", @"Emporio Armani",@"Gucci", @"LongChamp",@"Louis Vuitton", @"Michael Kors",  @"Prada", nil];
            
        }

        if (! gifts){
            gifts = [[NSArray alloc] initWithObjects: @"La Maison De Chocolate - Chocolates",@"Hudson News - News & Events",@"Relay - Magazines", @"Loccitane - Skin Care",@"Brookstone - Gadgets", @"CNBC News - Smart Shop", nil];
            
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
    
    NSInteger calories =  arc4random_uniform(350);
    
    cal = [NSString stringWithFormat:cal,calories];
    
    return cal;
    
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cellShopping",
    *restaurantName = @"",
    *locationFormat = @"Located in Terminal %@ - Near to Gate %d" ,
    *restaurantImageNameFormat = @"AirportShops_%d.jpg",
    *restaurantImageName = @"",
    *terminal = @"",
    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"H", @"T", nil];
    
    NSInteger terminalId = arc4random_uniform(Terminals.count),
                     gateId = arc4random_uniform(50),
                     imageId = 0;

    BOOL isParse = NO;
    
    if (gateId == 0){
        gateId = 1;
    }
    
    cell =  [tableView  dequeueReusableCellWithIdentifier:cellID];
    
    if (! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }

    
   imageId = indexPath.row;
    
    switch (indexPath.section) {
        case 0:

            restaurantName = [shops objectAtIndex:indexPath.row];
            isParse = YES;
            
            if (isParse) {
                
                UIImage *cellImage = [Utilities getParseImage:appDelegate.shopsbackgrounds anyIndex:indexPath.row];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
        case 1:
            restaurantImageNameFormat = @"GiftStore_%d.jpg";
            restaurantName = [gifts objectAtIndex:indexPath.row];
            break;
    }

    terminal = [Terminals objectAtIndex:terminalId];
    
    restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,imageId];
    
    terminal = [NSString stringWithFormat:@"%@",terminal];
    
    finalLocation = [NSString stringWithFormat:locationFormat, terminal,gateId];
    
    [cell.textLabel setText:restaurantName];
    
    [cell.detailTextLabel setText:finalLocation];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.accessoryView.tintColor = [UIColor whiteColor];
    if (! isParse){
        [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
    }
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



-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
            [header setText:@"Shopping"];
            break;
        case 1:
            [header setText:@"Concessions & Gift Stores"];
            break;
        }
    return header;
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
        
    
        NSString *rndFoodImgFormat          = @"AirportShops_%d_%d.jpg",
                        *rndFoodImgFormatToo    = @"AirportShops_X_%d.jpg",
                        *rndFoodImgName            = @"",
                        *shopTypeImageName       = @"";
        
        NSInteger rndFoodImgId = arc4random_uniform(10);
        

        [item.TempIMGView  setImage:[UIImage imageNamed:@"pos_terminal-100.png"]];
        
        [item.ArrDepIMGView setImage:[UIImage imageNamed:@"multiple_devices_filled-100.png"]];
        
        [item setFoodType:Dining];

        /*
            @"Burberry",@"Chanel",@"Coach", @"Emporio Armani",@"Gucci", @"LongChamp",@"Louis Vuitton", @"Michael Kors",  @"Prada"
         
         1.      Burberry – pls indicate – Fashionable Accessories and Clothing
         2.      Coach – pls indicate – Fashionable Accessories and Clothing
         3.      Gucci – pls indicate – Fashionable Accessories and Clothing
         4.      Longchamp – not sure; however, even if it is accessories, pls change up the icon that we are using for accessories to a picture of a purse for example.
         5.      Long champ – the pictures are not changing by the way on Longchamp.
         6.      Louis Vuitton – Fashionable Accessories
         7.      Michael Kors – Women’s Accessories
         8.      Prada – Designer Fashion – pls change the icon to a purse perhaps.
         
         */
        
        NSArray *cuisines = [[NSArray alloc] initWithObjects:@"Fashionable Accessories\n & Clothing", @"Fragrances",
                                                                                              @"Fashionable Accessories\n & Clothing", @"Menswear",
                                                                                              @"Fashionable Accessories\n & Clothing" , @"Luxury Leather\n Accessories",
                                                                                              @"Fashionable Accessories", @"Women’s Accessories", @"Designer Fashion",  nil],
        
                       *cuisinesImages = [[NSArray alloc] initWithObjects:@"coat-50.png", @"perfume_bottle-100.png", @"wallet_filled-50.png",
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
                                                                                                @"cosmetic_brush-100.png" ,@"electro_devices_filled-100.png",@"idea-100.png",nil],
        
                       *ratings  = [[NSArray alloc] initWithObjects:@"Online Pay", @"InStore Pay", nil];
        
        NSInteger cuisineId = indexPath.row,
                         giftId      = indexPath.row,
                         rateId      = arc4random_uniform(ratings.count);
                
        [item.weatherIMGView setImage:[UIImage imageNamed:shopTypeImageName]];

        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];

        
        [item.weatherIMGView setHidden:YES];
        [item.WeatherValue setHidden:YES];
        
        NSString *cuisine = @"",
                        *gift = @"",
                        *rating = [ratings objectAtIndex:rateId],
                        *hours  = @"Monday to Sunday 10 AM - 9 PM",
                        *phone    = [ItemViewController generateRandomPhone],
                        *site    = @"";
        
        NSArray *titleData = [title componentsSeparatedByString:@"-"];
        NSString *newTitle =  title;
        if (titleData){
            newTitle = [titleData firstObject];
            site  = [NSString stringWithFormat:@"www.%@.com", [newTitle stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        }
        
        switch (indexPath.section) {
            case 0:
                cuisine =   [cuisines objectAtIndex:cuisineId];
                 [item.Arrival_DepartureValue setText:cuisine];
                  shopTypeImageName = [cuisinesImages objectAtIndex:cuisineId];
                rndFoodImgId = cuisineId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                break;
                
            case 1:
                gift =  [giftTypes objectAtIndex:giftId],
                 [item.Arrival_DepartureValue setText:gift];
                shopTypeImageName = [giftImages objectAtIndex:giftId];
                rndFoodImgName =[NSString stringWithFormat:@"%@_%d.jpg", [gift stringByReplacingOccurrencesOfString:@" " withString:@""], giftId];
                break;
        }
        
        [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
        [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
        [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor colorWithHexString:@"f0f0f0"];
        [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
        
        UIImage *nImage = [UIImage imageNamed:shopTypeImageName];
        CGSize newSize = CGSizeMake(100, 100);
        
        if ([cuisine length] > 18 && indexPath.section == 0){
            newSize = CGSizeMake(60, 60);
            [item.Arrival_DepartureValue setFont:[UIFont fontWithName:@"Avenir Next" size:15.0f]];
        }
         nImage = [ItemViewController imageResize:nImage andResizeTo:newSize];
        [item.ArrDepIMGView setImage:nImage];
        
        [item.TempValue setNumberOfLines:0];
        [item.TempValue setText:@"ROP\n (Reserve, Order & Pay)"];
        
        //[item.WeatherValue setText:cuisine];
       // [item.Arrival_DepartureValue setText:shopTypeImageName];
        
        [item.FlightLabel setText:@"Hours: "];
        
        [item.FlightValue setText:hours];
        
        //rating = @"Purchase Now";
        
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
       
        
        [item.TerminalValue setText: [desc stringByReplacingOccurrencesOfString:@"Located in " withString:@""]];
        [item.instructionsLabel setText:newTitle];
        [item.StatusLabel setText:@"Phone Number: "];
        [item.StatusValue setText:phone];
        [item.AircraftLabel setText:@"Web Site: "];
        [item.AircraftValue setText:[site stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSInteger imgCount = 1;
        
        switch (indexPath.section) {
            case 0:
                rndFoodImgFormatToo  = [rndFoodImgFormatToo stringByReplacingOccurrencesOfString:@"X"
                                                                                      withString:[NSString stringWithFormat:@"%d",indexPath.row]];
                
                
                switch (indexPath.row) {
                    case 1:
                        
                        clothes = skin;
                        clothesImages = skinImages;
                        break;
                        
                    default:
                        break;
                }
                
              //  [item startRandomStatus:clothes :clothesImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                imgCount = 5;
                [item startTimer:rndFoodImgFormatToo :imgCount];

                break;
                
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                           rndFoodImgFormat = @"Chocolates_%d.jpg";
                        imgCount = 4;
                        break;
                    case 1:
                        rndFoodImgFormat = @"News&Events_%d.jpg";
                        imgCount = 4;
                        break;
                    case 2:
                        rndFoodImgFormat = @"Magazines_%d.jpg";
                        imgCount = 4;
                        break;
                    case 3:
                        rndFoodImgFormat = @"SkinCare_%d.jpg";
                        imgCount = 4;
                        break;
                    case 4:
                        rndFoodImgFormat = @"Gadgets_%d.jpg";
                        imgCount = 4;
                        break;
                    case 5:
                        rndFoodImgFormat = @"SmartShop_%d.jpg";
                        imgCount = 4;
                        break;
                }
                [item startTimer:rndFoodImgFormat :imgCount];
                break;
        }
 

 
        
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
    NSInteger sectionCount = 2  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    switch (section) {
        case 0:
         rows =   shops.count;
            break;
            
        default:
            rows = gifts.count;
            break;
    }
    return rows;
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

-(void) viewDidLoad{
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@"Shopping/Concessions & Gift Stores"]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkOrderCount];
}
@end
