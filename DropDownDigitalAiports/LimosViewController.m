//
//  LimosViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 7/18/15.
//  Copyright (c) 2015 Digital World International. All rights reserved.
//

#import "LimosViewController.h"
#import "UIColor+ColorWithHexString.h"
#import "ItemViewController.h"
#import "AppDelegate.h"

@interface LimosViewController (){
    NSArray *games;

UIImageView *selectedImageView;
AppDelegate *appDelegate;
    UIInterfaceOrientation currentOrientation;
}
@end

@implementation LimosViewController

-(void) initTablesData{
    
    NSString *message = @"";
    @try {
        
        if (!self.tableView){
            self.tableView = [[UITableView alloc] init];
        }
        
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        
        self.tableView.backgroundColor = [UIColor grayColor];
        
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

-(void) initGamesData{
    NSString *message = @"";
    @try {
        
        games = [[NSArray alloc] initWithObjects: @"Agoff Limousine & Bus Company", @"Elite Limousine Service",@"Infinity Limousine Inc.",@"Limo Bus",
                                                                             @"Platinum Limousine",@"Prestige Limousines",  @"Royal Limousine", @"Star Limousine", nil];

        
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

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.tableView.indexPathForSelectedRow){
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    //[self.navigationItem setTitleView:[self getSpecialTitleView:@"Limousine Services"]];
    [self initGamesData];
    [self initTablesData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Events

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
            [header setText:@"Limousine Services"];
            [self.navigationItem setTitleView:nil];
            [self setTitle:@""];
            [self.navigationItem setTitle:@""];
            break;
    }
    return header;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentRight];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
            [header setText:@""];
            break;
    }
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *message           = @"",
                    *title                   = @"",
                    *imageName             = @"",
                    *locationFormat        = @"Located inside of parking garages %@ and %@" ,
                    *locationOutside      = @"Located on the ground floor; Inside most terminals",
                    *hotelairportshuttle  = @"Located %d miles from airport; Please use shuttle outside each terminal",
                    *finalLocation           = @"",
                    *terminal                  = @"",
                    *terminalTo              = @"",
                     *cellId                     = @"";
    
    UITableViewCell *cell = nil;
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"H", @"T", nil];
    
    NSInteger terminalId = arc4random_uniform(Terminals.count -1),
                      terminalIdToo = terminalId + 1,
                      gateId =arc4random_uniform(Terminals.count / 2);
    
    if (gateId <= 1){
        gateId = 2;
    }
    
    @try {
        
        cellId = @"cbLimosCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (! cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
            
        }
        
        title = [games objectAtIndex:indexPath.row];
        terminal = [Terminals objectAtIndex:terminalId];
        terminalTo = [Terminals objectAtIndex:terminalIdToo];
        
        imageName = [NSString stringWithFormat:@"Limo_%d.png",indexPath.row];
        
        switch (indexPath.row) {
            case 7:
            case 1:
            case 5:
                finalLocation = [NSString stringWithFormat:hotelairportshuttle, gateId];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir Next" size:15.5f]];
                break;
            case 6:
            case 4:
            case 8:
                finalLocation = [NSString stringWithFormat:locationFormat, terminal,terminalTo];
                break;
            case 3:
            case 0:
            case 2:
                finalLocation =locationOutside;
                break;
        }
        
        [cell.detailTextLabel setText:@""];
        
        [cell.textLabel setTextColor: [UIColor blackColor]];
        
        //[cell.textLabel setFont:[UIFont fontWithName:@"Avenir Next" size:18.0f]];
        [cell.textLabel setText:title];
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
        
        UIImage *cellImage = nil;
        
        if (appDelegate.isiPhone){
            cellImage = [UIImage imageNamed:imageName];
            if (cellImage){
                cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(80, 70)];
            }
              [cell.imageView setImage:cellImage];
             [cell.textLabel setNumberOfLines:0];
             [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:kTitleIPhoneSize]];
          /*   [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:12.0f]];*/
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
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    
    rows = games.count;
    return rows;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = 1;
    return sections;
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
        
        
        NSString *rndFoodImgFormat    = @"LimoCar_%d.jpg",
                        *locationFormat = @"%d %@, Atlanta, GA, 30320" ,
                        *rndFoodImgName      = @"",
                        *shopTypeImageName = @"";
        
        NSInteger rndFoodImgId = arc4random_uniform(7);
        
        rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId];
        
        [item.imageView setImage:[UIImage imageNamed:rndFoodImgName]];
        [item.AirlineIMGView setImage:image];
        [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
        [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor colorWithHexString:@"f0f0f0"];
        [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
        [item.TempIMGView  setImage:[UIImage imageNamed:@"pos_terminal-100.png"]];
        
        [item.ArrDepIMGView setImage:[UIImage imageNamed:@"multiple_devices_filled-100.png"]];
        
        [item setFoodType:Dining];
        
  
        
        NSArray *Terminals = [[NSArray alloc] initWithObjects:@"Street", @"Avenue", @"Boulevard", @"Lane", @"Plaza", @"Road", nil],
        
                        *cuisines = [[NSArray alloc] initWithObjects:@"Champaign Bottle", @"Dvd & Flat Screen", @"Privacy Screen",
                             @"Satellite Radio" ,nil],
        
        *cuisinesImages = [[NSArray alloc] initWithObjects:@"champagne-100.png", @"tv-100.png", @"privacy-100.png",
                           @"online_filled-100.png" ,nil],
        
        *prices    = [[NSArray alloc] initWithObjects:@"Master Card", @"AmeEX",  @"Visa", nil],
        *ratings  = [[NSArray alloc] initWithObjects:@"Online Pay", @"InStore Pay", nil];
        
        NSInteger cuisineId = arc4random_uniform(cuisines.count),
                        priceId     = arc4random_uniform(prices.count),
                        rateId      = arc4random_uniform(ratings.count),
                        tid =  arc4random_uniform(Terminals.count),
                        aid = arc4random_uniform(2344);
        
        shopTypeImageName = [cuisinesImages objectAtIndex:cuisineId];
        
        [item.weatherIMGView setImage:[UIImage imageNamed:shopTypeImageName]];
        [item.ArrDepIMGView setImage:[UIImage imageNamed:shopTypeImageName]];
        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];
        
        
        [item.weatherIMGView setHidden:YES];
        [item.WeatherValue setHidden:YES];
        
        NSString *cuisine = [cuisines objectAtIndex:cuisineId],
        *price = [prices objectAtIndex:priceId],
        *rating = [ratings objectAtIndex:rateId],
        *phone    = [ItemViewController generateRandomPhone],
        *add    = [NSString stringWithFormat:locationFormat, aid,[Terminals objectAtIndex:tid]],
        *hours  = @"Monday to Sunday 8 AM - 10 PM",
        *site    = [NSString stringWithFormat:@"www.%@.com",
                    [title stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        
 
        
        price = @"R.O.P.\n (Reserve, Order & Pay)";
        [item.TempValue setNumberOfLines:0];
        [item.TempValue setText:price];
        
        //[item.WeatherValue setText:cuisine];
        [item.Arrival_DepartureValue setText:shopTypeImageName];
        
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
        [item.Arrival_DepartureValue setText:cuisine];
        [item.TerminalLabel setText:@"Address:"];
        [item.TerminalValue setText: add];
        [item.instructionsLabel setText:title];
        [item.StatusLabel setText:@"Phone: "];
        if (appDelegate.isiPhone){
            switch (appDelegate.screenHeight) {
                case 736:
                    //tread as ipad
                    
                    if (site.length >= 37){
                        [item.AircraftValue setNumberOfLines:0];
                        [item.AircraftValue  setFont:[UIFont systemFontOfSize:14.0f]];
                    }
                    
                    break;
                default:
                    phone = [NSString stringWithFormat:@"\n%@",phone];
                    break;
            }
        }
        [item.StatusValue setText:phone];
        [item.AircraftLabel setText:@"Web Site: "];
        [item.AircraftValue setText:[site stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        
        [item startRandomStatus:cuisines :cuisinesImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
        
        // [ item startTimer:rndFoodImgFormat :10];
        
        
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
#pragma mark - Navigation


-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    BOOL result = YES;
    /*  NSString *segName = identifier;
     
     if (! [segName length] > 0){
     result = NO;
     }*/
    
    return result;
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
                
                CGRect   tableRect = CGRectMake(0.0f, 0.0f, 1024,768);
            
                [self.tableView setFrame:tableRect];
             
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



@end
