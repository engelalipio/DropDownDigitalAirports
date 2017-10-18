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
                   *airportCategories,
                   *externalCategories;
    
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
    CGFloat headerH = 1.0f;
    
    return headerH;
}

-(UIView *) customLabelRow:(NSString *)anyText{
    UILabel *header = nil;
    NSInteger size = 20.0f;
    
    NSTextAlignment alignment = NSTextAlignmentCenter;
    
    
    if (appDelegate.isiPhone){
        size = 18.0f;
    }
   
            header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 35)];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
 
            [header setText:anyText];
  

    return header;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    NSInteger size = 20.0f;
    
    NSTextAlignment alignment = NSTextAlignmentCenter;
    
    
    if (appDelegate.isiPhone){
        size = 18.0f;
    }
    switch (section) {
        case 0:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
            if (_categoryTitle){
                if (_isRetail){
                    [self.navigationItem setTitle:@"Explore BWI’s Restaurants/Shops"];
                    //[header setText:@"Explore BWI’s Restaurants/Shops"];
                }else{
                     [self.navigationItem setTitle:@"Local Area Restaurants/Retail Stores"];
                    //[header setText:@"Local Area Restaurants/Retail Stores"];
                }
                //[header setText:_categoryTitle];
            }
           //[header setText:[NSString stringWithFormat:@"%lu Total Categories",(unsigned long)airportCategories.count]];
            break;
        case 1:
            header = [[UILabel alloc] init];
            [header setFont:[UIFont fontWithName:@"Avenir Medium" size:size]];
            [header setTextAlignment:alignment];
            [header setTextColor:[UIColor whiteColor]];
            [header setBackgroundColor:[UIColor blackColor]];
            if (_categoryTitle){
                if (_isRetail){
                    [self.navigationItem setTitle:@"Local Area Restaurants/Retail Stores"];
                  //  [header setText:@"Local Area Restaurants/Retail Stores"];
                }else{
                     [self.navigationItem setTitle:@"Explore BWI’s Restaurants/Shops"];
                  //  [header setText:@"Explore BWI’s Restaurants/Shops"];
                }
                //[header setText:_categoryTitle];
            }
        
            
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
    
    
    int row = 0,
        sec = 0;
    
    if (indexPath.section){
        sec = indexPath.section;
    }
    
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
    
    switch (sec) {
        case 0:
            
            if (_isRetail){
                switch (indexPath.row) {
                    case 0:
                        

                            terminalId = arc4random_uniform(appDelegate.diningbackgrounds.count);
                            image = [Utilities getAzureStorageImage:appDelegate.diningbackgrounds anyIndex:terminalId];
                            terminalId = (appDelegate.diningbackgrounds.count + appDelegate.foodtogobackgrounds.count + appDelegate.foodcourtbackgrounds.count);
                            finalLocation = [airportCategories objectAtIndex:indexPath.row];
                            storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                       
                        
                        break;
                        
                    case 1:

                            terminalId = arc4random_uniform(appDelegate.shopsbackgrounds.count);
                            image = [Utilities getAzureStorageImage:appDelegate.shopsbackgrounds anyIndex:terminalId];
                            terminalId = (appDelegate.shopsbackgrounds.count + appDelegate.loungesbackgrounds.count );
                            finalLocation = [airportCategories objectAtIndex:indexPath.row];
                            storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        
                        break;
                        
                        
 
            }
        }
            else{
                switch (indexPath.row) {
                    case 0:
                        
                        terminalId = arc4random_uniform(appDelegate.extDiningbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.extDiningbackgrounds anyIndex:terminalId];
                        finalLocation = [externalCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        
                        
                        break;
                        
                    case 1:
                        
                        terminalId = arc4random_uniform(appDelegate.extShopsbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.extShopsbackgrounds anyIndex:terminalId];
                        finalLocation = [externalCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        
                        break;
                        
                        
                }
            }
            break;
            
         
        case 1:
            
            if (_isRetail){
                switch (indexPath.row) {
                    case 0:
                        
                        terminalId = arc4random_uniform(appDelegate.extDiningbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.extDiningbackgrounds anyIndex:terminalId];
                        finalLocation = [externalCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        

                        
                        
                        break;
                        
                    case 1:
                        terminalId = arc4random_uniform(appDelegate.extShopsbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.extShopsbackgrounds anyIndex:terminalId];
                        finalLocation = [externalCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        

                        break;
                        
                        
                }
            }
            else{
                switch (indexPath.row) {
                    case 0:
                        
                        terminalId = arc4random_uniform(appDelegate.diningbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.diningbackgrounds anyIndex:terminalId];
                        terminalId = (appDelegate.diningbackgrounds.count + appDelegate.foodtogobackgrounds.count + appDelegate.foodcourtbackgrounds.count);
                        finalLocation = [airportCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        
                        
                        break;
                        
                    case 1:
                        
                        terminalId = arc4random_uniform(appDelegate.shopsbackgrounds.count);
                        image = [Utilities getAzureStorageImage:appDelegate.shopsbackgrounds anyIndex:terminalId];
                        terminalId = (appDelegate.shopsbackgrounds.count + appDelegate.loungesbackgrounds.count );
                        finalLocation = [airportCategories objectAtIndex:indexPath.row];
                        storeCount = [NSString stringWithFormat:@"%ld",(long)terminalId];
                        
                        
                        break;
                        
                        
                }
            }
            
            
            break;
    }
    

 
        

        
        if (image){
            
         
            
            if (appDelegate.isiPhone){
                
                
                image = [Utilities imageResize:image andResizeTo:CGSizeMake(700.0f, 600.0f)];
               
 
            }else{
                image = [Utilities imageResize:image andResizeTo:CGSizeMake(1000.0f, 600.0f)];
            }
        }
 
        
 
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setHidden:YES];
    [cell.textLabel setText:finalLocation] ;
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ Stores",storeCount]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryView.tintColor = [UIColor whiteColor];
    [cell.imageView setImage:image];
    
    [cell.contentView addSubview: [self customLabelRow:finalLocation]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            [tableView setBackgroundColor:UIColor.blackColor];
            cell.contentView.superview.backgroundColor =    UIColor.blackColor;;// kVerticalTableBackgroundColor;
          
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

                [self performSegueWithIdentifier:@"segDining" sender:self];

                break;
                
            case 1:
 
                [self performSegueWithIdentifier:@"segShops" sender:self];
               
                break;
        }

        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        row = -1;
    }
    
    
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger size = 220;
    if (appDelegate.isiPhone){
        switch (appDelegate.screenHeight) {
            case 736:
                size = 150;
                break;
                
            default:
                size = 65;
                break;
        }
    }
    size = (size * 2);
    return size;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (section) {
        case 0:
            if (_isRetail){
                rowCount = airportCategories.count;
            }else{
                rowCount = externalCategories.count;
            }
            
            break;
        case 1:
            if (_isRetail){
                rowCount = airportCategories.count;
            }else{
                rowCount = externalCategories.count;
            }
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
    
 
        airportCategories = [[NSArray alloc] initWithObjects:
                             @"Fine Dining/Meals To Go/The Food Court",
                             @"Shopping/Concessions & Gift Stores", nil];
        
        externalCategories = [[NSArray alloc] initWithObjects:
                             @"Local Area Restaurants",
                             @"Local Area Retail Stores", nil];
    
    
    
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
    
    if ([categoryName isEqualToString:@"Local Area Retail Stores"]){
        [fVC setIsExternal:YES];
    }
    
    if ([categoryName isEqualToString:@"Local Area Restaurants"]){
        [dVC setIsExternal:YES];
    }
 
    
}


@end
