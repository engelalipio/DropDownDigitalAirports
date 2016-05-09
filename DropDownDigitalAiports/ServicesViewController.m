//
//  OrderViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/10/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "ServicesViewController.h"
#import "PaymentMethodViewController.h"
#import "Constants.h"
#import "itemModel.h"
#import "AppDelegate.h"
#import "HeaderImageCell.h"
#import "NumberFormatter.h"
#import "ItemViewController.h"

@interface ServicesViewController(){
    AppDelegate         *appDelegate;

}

@end

@implementation ServicesViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
 

}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    appDelegate = [AppDelegate currentDelegate];
    
}



-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            UIImage *cellImage = nil;
            NSInteger size = 13.0f;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
                if (cellImage){
                    
                    switch (appDelegate.screenHeight) {
                        case 736:
                            cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(120,120 )];
                            break;
                            
                        default:
                                cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(100,100 )];
                            break;
                    }

                }


                [cell.imageView setImage:cellImage];
            /*    [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:15.0f]];
                [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size: size]];*/
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat size = 120.0f;
    if ((indexPath.row ==  4 || indexPath.row == 9) && (appDelegate.isiPhone)){
        size = 160.0f;
    }
    return size;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 10;

    return    rows;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = 1;
    return    sections;
}


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentRight];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
          //  [header setText:@"Airport Services"];
            break;
    }
    return header;
}



@end
