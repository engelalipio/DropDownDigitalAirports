//
//  CategoriesViewController.m
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 11/5/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//
#import "DiningViewController.h"
#import "ShopsViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "CategoriesTableViewController.h"

@interface CategoriesTableViewController()
{
    NSMutableArray *menuTitles,
                   *airportCategories;
    
    AppDelegate *appDelegate;
    
    UIImageView *selectedImageView;
    
    NSString *airlineName,
             *airlineLogo;
    
}

-(void) initTableView;
@end

@implementation CategoriesTableViewController


@synthesize  isRetail = _isRetail;
@synthesize categoryTitle = _categoryTitle;
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
            if (_categoryTitle){
                [header setText:_categoryTitle];
            }
           //[header setText:[NSString stringWithFormat:@"%lu Total Categories",(unsigned long)airportCategories.count]];
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
             *finalLocation = @"",
             *storeCount = @"";
    
    UIImage *image = nil;
    
    
    int row = 0;
    
    if (indexPath.row){
        row = indexPath.row;
    }
    
    
    cell =  [tableView  dequeueReusableCellWithIdentifier:cellID];
    
    
    if (! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }
    
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects: @"The Dolphin Entrance",@"The Main Entrance",@"The North Entrance",
                          @"The South Entrance", @"The West Entrance", @"The East Entrance" , nil];
    
    
    NSInteger terminalId = arc4random_uniform(Terminals.count);
    
    switch (indexPath.row) {
        case 0:
            
            if (_isRetail){
            terminalId = arc4random_uniform(appDelegate.diningbackgrounds.count);
            image = [Utilities getAzureStorageImage:appDelegate.diningbackgrounds anyIndex:terminalId];
            terminalId = (appDelegate.diningbackgrounds.count + appDelegate.foodtogobackgrounds.count + appDelegate.foodcourtbackgrounds.count);
            finalLocation = [airportCategories objectAtIndex:indexPath.row];
            storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
            }else{
                terminalId = arc4random_uniform(appDelegate.sightseeingbackgrounds.count);
                image = [Utilities getAzureStorageImage:appDelegate.sightseeingbackgrounds anyIndex:terminalId];
                terminalId = (appDelegate.sightseeingbackgrounds.count);
                finalLocation = [airportCategories objectAtIndex:indexPath.row];
                storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
            }
            
            break;
            
        case 1:
            if (_isRetail){
                terminalId = arc4random_uniform(appDelegate.shopsbackgrounds.count);
                image = [Utilities getAzureStorageImage:appDelegate.shopsbackgrounds anyIndex:terminalId];
                terminalId = (appDelegate.shopsbackgrounds.count + appDelegate.loungesbackgrounds.count );
                finalLocation = [airportCategories objectAtIndex:indexPath.row];
                storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
            }else{
                terminalId = arc4random_uniform(appDelegate.hotelbackgrounds.count);
                image = [Utilities getAzureStorageImage:appDelegate.hotelbackgrounds anyIndex:terminalId];
                terminalId = (appDelegate.hotelbackgrounds.count );
                finalLocation = [airportCategories objectAtIndex:indexPath.row];
                storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
            }
            
            break;
    }
 
        

        
        if (image){
            
         
            
            if (appDelegate.isiPhone){
                
                
                image = [ItemViewController imageResize:image andResizeTo:CGSizeMake(120, 100)];
               
 
            }else{
                image = [Utilities imageResize:image andResizeTo:CGSizeMake(1000.0f, 600.0f)];
            }
        }
 
        
 
    
    [cell.textLabel setText:finalLocation] ;
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ Stores",storeCount]];
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
                /* if (cellImage){
                 cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90,50)];
                 if (cellImage.size.width > 200.0f){
                 cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(80,cellImage.size.height / 2)];
                 [cell.imageView setImage:cellImage];
                 }
                 }
                 
                 [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:12.0f]];
                 [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:11.0f]];*/
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
    
    
 
    NSInteger row = -1;
    
    @try {
        

        row = indexPath.row;
        
        
        switch (row) {
            case 0:
                if (_isRetail){
                    [self performSegueWithIdentifier:@"segDining" sender:self];
                }else{
                    [self performSegueWithIdentifier:@"segAttractions" sender:self];
                }
                break;
                
            case 1:
                if (_isRetail){
                 [self performSegueWithIdentifier:@"segShops" sender:self];
                }
                else{
                  [self performSegueWithIdentifier:@"segHotels" sender:self];
                }
                break;
        }

        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        row = -1;
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
            rowCount = airportCategories.count;
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
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    
    if (! _isRetail){
        airportCategories = [[NSArray alloc] initWithObjects:@"Area Attractions",@"Nearby Hotels", nil];
    }else{
 
        airportCategories = [[NSArray alloc] initWithObjects:@"Fine Dining/Meals To Go/The Food Court",@"Shopping/Concessions & Gift Stores", nil];
    }
 
    
    
    [self initTableView];
    // [self.navigationItem setTitleView:[self getSpecialTitleView:@"Mall Categories"]];
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
    
    NSString *catName = @"",
             *categoryName = @"",
             *catLogo = @"";
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    if (selectedCell){
        categoryName = selectedCell.textLabel.text;
    }
    
    ShopsViewController *fVC = (ShopsViewController *) [segue destinationViewController];
    
    DiningViewController *dVC = (DiningViewController*) [segue destinationViewController];
    
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:
             
            break;
            
        default:
            break;
    }
 
    
}


@end
