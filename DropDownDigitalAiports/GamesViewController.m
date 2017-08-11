//
//  SecondViewController.m
//  DropDownDigitalMenus
//
//  Created by Engel Alipio on 10/22/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "GamesViewController.h"
#import "GameViewController.h"
#import "UIColor+ColorWithHexString.h"
#import "AppDelegate.h"

@interface GamesViewController ()
{
    
    NSArray *games,
            *gamesImages;
    
    AppDelegate *appDelegate;
    
    BOOL isNative ;
}

-(void)initGamesData;
-(void)initTablesData;

@end

@implementation GamesViewController


-(void) initTablesData{
    
    NSString *message = @"";
    @try {
        
        if (!self.tableView){
            self.tableView = [[UITableView alloc] init];
        }
        
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"004080"];//kVerticalTableBackgroundColor;
        
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
        
        isNative = YES;
        
        games = [[NSArray alloc] initWithObjects: @"Pop Pop Rush", @"Smarty Bubbles", @"Speed Pool King",@"Mahjong",@"Fit It Quick",@"Cartoon Flight",nil];
        
        gamesImages = [[NSArray alloc] initWithObjects: @"PopPopRush.png", @"SmartyBubbles.png",  @"SpeedPoolKing.png",@"Mahjong.png",@"FitItQuick.png",@"CartoonFlight.png",nil];
        
        if (isNative){
            games = [[NSArray alloc] initWithObjects: @"Simon", @"Celebro Trivia",@"Meteor",@"Draw Pad",@"Bug Crush",@"Snap",nil];
            
            gamesImages = [[NSArray alloc] initWithObjects: @"Simon.png", @"Celebro.png",@"Meteor.png",@"DrawPad.png",@"BugCrush.png",@"Snap.png",nil];
            
        }
        [self.tableView reloadData];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initGamesData];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.tableView.indexPathForSelectedRow){
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    }
    games = nil;
    gamesImages = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initTablesData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Events



-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *message   = @"",
    *title     = @"",
    *imageName = @"",
    *cellId    = @"";
    
    UITableViewCell *cell = nil;
    
    @try {
        
        
        cellId = @"cbGamesCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (! cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
            
        }
        
        title = [games objectAtIndex:indexPath.row];
        
        imageName = [gamesImages objectAtIndex:indexPath.row];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setBackgroundColor:self.tableView.backgroundColor];
        [cell.textLabel setTextColor: [UIColor whiteColor]];//[UIColor colorWithHexString: @"800000"]];
        

        
        [cell.textLabel setFont:[UIFont systemFontOfSize:25.0]];
        if (appDelegate.isiPhone){
            [cell.textLabel setFont:[UIFont systemFontOfSize:20.0]];
        }
        [cell.textLabel setText:title];
        
        if (appDelegate.isiPhone){
            UIImage *img = [UIImage imageNamed:imageName];
            
            img =  [Utilities imageResize:img andResizeTo:CGSizeMake(80, 100)];
            [cell.imageView setImage:img];
        }else{
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (! isNative){
        return;
    }
    
    NSIndexPath *selectedIP = indexPath;
    
    
    NSString *gameURL = @"",
    *gameName = [games objectAtIndex:[selectedIP row]];
    
    // @"Simon", @"Fox The Explorer",@"Four At A Time",@"Kart Patrol",@"Bug Crush",@"Light Bots",nil];
    
    
    switch([selectedIP row]){
        case 0:
            gameURL = @"RBGY://";
            isNative = YES;
            break;
        case 1:
            gameURL = @"CLBR://";
            isNative = YES;
            break;
        case 2:
            gameURL = @"MTOR://";//@"FIAR://";
            isNative = YES;
            break;
        case 3:
            gameURL = @"DrawPad://";
            isNative = YES;
            break;
        case 4:
            gameURL = @"BugCrush://";
            isNative = YES;
            break;
        case 5:
            gameURL = @"Snap://";
            isNative = YES;
            break;
    }
    
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:gameURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gameURL]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Launch Error"
                                                        message:[NSString stringWithFormat:
                                                                 @"Unable to Launch %@", gameURL]
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - Navigation


-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    BOOL result = ! isNative;
    /*  NSString *segName = identifier;
     
     if (! [segName length] > 0){
     result = NO;
     }*/
    
    return result;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedIP = [self.tableView indexPathForSelectedRow];
    
    GameViewController *destVC = (GameViewController*) [segue destinationViewController];
    
    NSString *gameURL = @"",
    *gameName = [games objectAtIndex:[selectedIP row]];
    
    // @"Simon", @"Fox The Explorer",@"Four At A Time",@"Kart Patrol",@"Bug Crush",@"Light Bots",nil];
    
    
    /*  switch([selectedIP row]){
     case 0:
     gameURL = @"RBGY://";
     isNative = YES;
     break;
     case 1:
     gameURL = @"Fox://";
     isNative = YES;
     break;
     case 2:
     gameURL = @"FIAR://";
     isNative = YES;
     break;
     case 3:
     gameURL = @"KartPatrol://";
     isNative = YES;
     break;
     case 4:
     gameURL = @"BugCrush://";
     isNative = YES;
     break;
     case 5:
     gameURL = @"Snap://";
     isNative = YES;
     break;
     }*/
    
    switch([selectedIP row]){
        case 5:
            gameURL = @"play.famobi.com/cartoon-flight";
            
            break;
        case 0:
            gameURL = @"play.famobi.com/pop-pop-rush";
            break;
        case 1:
            gameURL = @"play.famobi.com/smarty-bubbles";
            break;
        case 2:
            gameURL = @"play.famobi.com/speed-pool-king";
            break;
        case 3:
            gameURL = @"play.famobi.com/mahjong-relax";
            break;
        case 4:
            gameURL = @"play.famobi.com/fit-it-quick";
            break;
    }
    
    if (! isNative){
        if (destVC){
            [destVC setGameURL:gameURL];
            [destVC setGameName:gameName];
        }
    }else{
        
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:gameURL]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gameURL]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Launch Error"
                                                            message:[NSString stringWithFormat:
                                                                     @"Unable to Launch %@", gameURL]
                                                           delegate:self cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}

@end
