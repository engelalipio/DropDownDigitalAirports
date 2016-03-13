//
//  LanguagesViewController.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 12/12/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "LanguagesViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface LanguagesViewController(){
    NSArray *languages;
    AppDelegate *appDelegate;
    NSString *selectedLanguage;
    UIInterfaceOrientation currentOrientation;
}
-(void) initLanguages;
-(void) initTableView;
-(void) selectLanguage;

@end

@implementation LanguagesViewController

-(void)viewWillAppear:(BOOL)animated
{
   
}


-(void) viewDidLoad{
    [super viewDidLoad];
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initLanguages];
    [self initTableView];
}


-(void) initLanguages{
    
    NSString *message = @"";
    
    @try{
        
        
        if (! languages){
            languages = [[NSArray alloc] initWithObjects:@"English", @"Spanish", @"French",
                         @"Italian", @"Portuguese", @"German", @"Russian", @"Dutch", @"Korean", @"Croatian",@"Greek",  nil];
        }
    
        
        
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

-(void) initTableView{
    
    NSString *message = @"";
    
    @try{
    
        
        if (! self.tableView){
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, kTableYStart, kTabletWidth, kTableHeight)];
        }
        
        
        //self.tableView.backgroundColor =  kVerticalTableBackgroundColor;
        
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


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentRight];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
         //   [header setText:@"Available Languages"];
            break;
    }
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat size = 120.0f;
    if (appDelegate.isiPhone){
        size =  size /2;
    }
    return size;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIAlertView *alert = nil;
    
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    
    switch (buttonIndex) {
        case 0:
            

            if (selectedIndex){
                [self.tableView deselectRowAtIndexPath:selectedIndex animated:YES];
            }

            break;
        case 1:
            
            alert = [[UIAlertView alloc] initWithTitle:@"Language Selection Confirmation"
                                               message:[NSString stringWithFormat:@"Your preferred language was sucessfully changed to %@",selectedLanguage]delegate:self
                                     cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            if (alert){
                [alert show];
            }
            
            [appDelegate setLanguage:selectedLanguage];
            
            
            
            
            break;
        
    }
}


-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSString *language = @"",
             *message  = @"";
    
    UIAlertView *alert = nil;
    
    @try {
        
        language = [languages objectAtIndex:[indexPath row]];
        
        
        selectedLanguage = language;
        
        message = [NSString stringWithFormat:@"Are you sure you want select %@ as your preferred language?",selectedLanguage];
        
        alert = [[UIAlertView alloc] initWithTitle:@"Change Language" message:message delegate:self
                                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        if (alert){
            [alert show];
        }
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        alert = nil;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *message   = @"",
                    *title     = @"",
                    *titleLabel = @"",
                    *imageName = @"",
                    *cellId    = @"";
    
    UITableViewCell *cell = nil;
    
    NSInteger fontTitleSize = 25.0f,
                      fontTextSize = 18.0f;
    
    
    @try {
        
        

        
        cellId = @"cbLanguageCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (! cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellId];
            
        }
        
        title = [languages objectAtIndex:indexPath.row];
        
        titleLabel =  [NSString stringWithFormat:@"Click on the informational button to switch to %@",title];
        
        if (appDelegate.isiPhone){
            fontTitleSize = 15.0f;
            fontTextSize = 13.0f;
            titleLabel = @"Click on the 'I' to switch";
        }
        
        imageName = [NSString stringWithFormat:@"%@.png",[title uppercaseString]];
        [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
 
       // [cell.textLabel setTextColor: [UIColor blackColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir Next" size:fontTitleSize]];
        [cell.textLabel setText:title];
        
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir Book" size:fontTextSize]];
        [cell.detailTextLabel setText:titleLabel];
        
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
        
        
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



-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
           // cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
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
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1  ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 1;
    
    switch (section) {
        case 0:
            rowCount = languages.count;
            break;
            
    }
    return rowCount;
}

-(void) selectLanguage{
    
    NSIndexPath *indexPath = nil;
    NSString    *language = @"";
    NSInteger   languageIndex = -1;
    
    language = [appDelegate language];
    
    languageIndex = [languages indexOfObject:language];
    
    if (languageIndex > -1){
        indexPath = [NSIndexPath indexPathForRow:languageIndex inSection:0];
        
        if (indexPath){
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selectLanguage];
 
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
