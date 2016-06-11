//
//  AppDelegate.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "NetworkAPISingleClient+FIDS.h"
#import "DataModels.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize drinkItems = _drinkItems;
@synthesize saladItems = _saladItems;
@synthesize soupItems  = _soupItems;
@synthesize entreeItems  = _entreeItems;
@synthesize dessertItems = _dessertItems;
@synthesize appItems = _appItems;
@synthesize currentOrderItems = _currentOrderItems;
@synthesize language = _language;
@synthesize isDynamic = _isDynamic;
@synthesize restaurantTable = _restaurantTable;
@synthesize restaurantName = _restaurantName;
@synthesize restaurantAddress = _restaurantAddress;
@synthesize restaurantCity = _restaurantCity;
@synthesize restaurantState = _restaurantState;
@synthesize restaurantZip = _restaurantZip;
@synthesize interval = _interval;
@synthesize isSent = _isSent;
@synthesize isPaid = _isPaid;
@synthesize isiPhone = _isiPhone;
@synthesize backgrounds = _backgrounds;
@synthesize flightbackgrounds = _flightbackgrounds;
@synthesize diningbackgrounds = _diningbackgrounds;
@synthesize foodcourtbackgrounds = _foodcourtbackgrounds;
@synthesize foodtogobackgrounds = _foodtogobackgrounds;
@synthesize shopsbackgrounds = _shopsbackgrounds;
@synthesize loungesbackgrounds = _loungesbackgrounds;
@synthesize clubsbackgrounds = _clubsbackgrounds;
@synthesize hotelbackgrounds = _hotelbackgrounds;
@synthesize groundbackgrounds = _groundbackgrounds;
@synthesize screenHeight = _screenHeight;
@synthesize arrivals = _arrivals;
@synthesize departures = _departures;
@synthesize airlines = _airlines;
@synthesize selectedAirlineName = _selectedAirlineName;
@synthesize selectedAirlineLogo = _selectedAirlineLogo;
@synthesize locationManager = _locationManager;
@synthesize useAPI = _useAPI;
@synthesize  isMissingPerson = _isMissingPerson;
@synthesize  missingPersonImage = _missingPersonImage;

+(AppDelegate *) currentDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)tabBarController:(UITabBarController *)tabBarControllerThis didSelectViewController:(UIViewController *)viewController
{
    [UIView transitionWithView:viewController.view
                      duration:0.1
                       options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void){
                    } completion:^(BOOL finished){
                        [UIView beginAnimations:@"animation" context:nil];
                        [UIView setAnimationDuration:0.7];
                        [UIView setAnimationBeginsFromCurrentState:YES];
                        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                                               forView:viewController.view
                                                 cache:NO];
                        [UIView commitAnimations];
                    }];
}


- (UIStoryboard *)grabStoryboard {
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    switch (screenHeight) {
            
            // iPhone 4s
        case 480:
            //   storyboard = [UIStoryboard storyboardWithName:@"Main-4s" bundle:nil];
            break;
            
            // iPhone 5s
        case 568:
            //storyboard = [UIStoryboard storyboardWithName:@"Main-5s" bundle:nil];
            break;
            
            // iPhone 6
        case 667:
            // storyboard = [UIStoryboard storyboardWithName:@"Main-6" bundle:nil];
            break;
            
            // iPhone 6 Plus
        case 736:
            storyboard = [UIStoryboard storyboardWithName:@"Main_6Plus" bundle:nil];
            break;
            
        default:
            // storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
    }
    
    return storyboard;
}

-(void) retrieveAirportFIDSArrivals{
    
    [NetworkAPISingleClient retrieveArrivals:kFlightStatsMaxCount completionBlock:^(NSArray *arrData) {
        
        if (arrData){
            
            BaseClass *baseFids =  (BaseClass*) [arrData firstObject];
            
            if (baseFids){
                
                NSArray *arrivalsArray = [baseFids fidsData];
                NSMutableArray   *airlinesArray = [[NSMutableArray alloc] init];
                
                if (arrivalsArray){
                    _arrivals = [[NSMutableDictionary alloc] initWithCapacity:arrivalsArray.count];
                    
                    if (self.arrivals.count == 0){

                        NSString * filePath =[[NSBundle mainBundle] pathForResource:@"FIDS" ofType:@"json"];
                        
                        NSError * error;
                        NSString* fileContents =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
                    
                        if(error){
                            NSLog(@"Error reading file: %@",error.localizedDescription);
                        }
                        
                        NSDictionary* fData = (NSDictionary *)[NSJSONSerialization
                                                             JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0 error:NULL];
                        
                        arrivalsArray = [fData objectForKey:@"fidsData"];
                        
                        _arrivals = [[NSMutableDictionary alloc] initWithCapacity:arrivalsArray.count];
                        _departures = [[NSMutableDictionary alloc] initWithCapacity:arrivalsArray.count];
                        
                    }else{
                        _useAPI = YES;
                    }
                    
                    [_arrivals setValue:arrivalsArray forKey:@"Arrivals"];
                    [_departures setValue:arrivalsArray forKey:@"Departures"];
                    
                    NSString *airlineName = @"";
        
                    int fCount = 0;
                    
                    for (int idx = 0; idx < arrivalsArray.count; idx++) {
                        
                        FidsData *fidsData = [[FidsData alloc] init];
                        
                                         fidsData = [FidsData objectFromJSONObject:[arrivalsArray objectAtIndex:idx]
                                                                           mapping:[fidsData dictionaryRepresentation]];
                        
                        if (![fidsData.airlineName isEqualToString:airlineName]){
                            [airlinesArray addObject:fidsData];
                        }
                            airlineName = fidsData.airlineName;
                    }
                    
                
                    if (! self.airlines){
                        _airlines = [[NSMutableDictionary alloc] initWithCapacity:airlinesArray.count];
                        [_airlines setValue:airlinesArray forKey:@"Airlines"];
                    }
                    
                }
            }
        }
        
        
    }andErrorBlock:^(NSError *arrError){
        
        if (arrError){
            NSLog(@"%@",arrError.description);
        }
        
    }];
    
}


-(void) retrieveAirportFIDSDepartures{
    
 
    [NetworkAPISingleClient retrieveDepartures:kFlightStatsMaxCount completionBlock:^(NSArray *destData) {
        
        if (destData){
            
            BaseClass *baseFids =  (BaseClass*) [destData firstObject];
            
            if (baseFids){
                NSArray *destArray = [baseFids fidsData];
                
                if ([destArray count]){
                    _departures = [[NSMutableDictionary alloc] initWithCapacity:destArray.count];
                    [_departures setValue:destArray forKey:@"Departures"];
                }
            }
            
        }
        
        
    }andErrorBlock:^(NSError *arrError){
        
        if (arrError){
            NSLog(@"%@",arrError.description);
        }
        
    }];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _language = @"English";
    _isDynamic = YES;
    _isSent   = NO;
    _isiPhone = NO;
    _useAPI = NO;
    _restaurantTable     = @"Welcome To DropDownDigitalMenus.Com\n Proudly Serving All Airports";
    _restaurantName    = @"Sample International Airport ®";
    _restaurantAddress = @"2100 North West 42nd Avenue";
    _restaurantCity       = @"Miami";
    _restaurantState     = @"FL";
    _restaurantZip         = @"33142";
    _interval                   = 4;
    [self initLocationServices];
    [self initParseFramework];
    [self prepareAirportbackgrounds];
    [self retrieveAirportFIDSArrivals];
    [self retrieveAirportFIDSDepartures];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        _isiPhone = YES;
        // grab correct storyboard depending on screen height
        UIStoryboard *storyboard = [self grabStoryboard];
        
        // display storyboard
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
        
    }
    
    
    NSLog(@"Screen Height -> %ld",(long)_screenHeight);
    
    return YES;
}

-(void) initLocationServices{
    
    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager setDelegate:self];
    
}

-(void) initParseFramework{
    
    NSDictionary *infoDictionary = nil;
    NSString *message = @"",
                    *appKey   = kParseAppId,
                    *clientKey = kParseKey;
    
    @try {
        
        infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        [Parse setApplicationId:appKey clientKey:clientKey];
        
        message = [NSString  stringWithFormat:@"Successfully initialized Parse for %@ - %@",appKey,clientKey];
        
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        appKey = @"";
        clientKey = @"";
        infoDictionary = nil;
    }
    
}

-(void) prepareAirportbackgrounds{
    
    
    PFQuery *query = nil;
    @try {
        
        query = [PFQuery queryWithClassName:@"Airportbackgrounds"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                if (error){
                    message = [NSString stringWithFormat: @"Airportbackgrounds:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"Airportbackgrounds:findObjectsInBackgroundWithBlock:Airport Background Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _backgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportFlights"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                if (error){
                    message = [NSString stringWithFormat: @"AirportFlights:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportFlights:findObjectsInBackgroundWithBlock:Flights Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _flightbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportDining"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                if (error){
                    message = [NSString stringWithFormat: @"AirportDining:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportDining:findObjectsInBackgroundWithBlock:Restaurant Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _diningbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportFoodCourts"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                if (error){
                    message = [NSString stringWithFormat: @"AirportFoodCourts:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportFoodCourts:findObjectsInBackgroundWithBlock:Food Court Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _foodcourtbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportFoodToGo"];
        
        if (query){
        
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                if (error){
                    message = [NSString stringWithFormat: @"AirportFoodToGo:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportFoodToGo:findObjectsInBackgroundWithBlock:Food ToGo Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _foodtogobackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportShops"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";

                if (error){
                    message = [NSString stringWithFormat: @"AirportShops:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportShops:findObjectsInBackgroundWithBlock:Shops Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _shopsbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }

        query = [PFQuery queryWithClassName:@"AirportLounges"];
        
        if (query){

            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                
                if (error){
                    message = [NSString stringWithFormat: @"AirportLounges:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportLounges:findObjectsInBackgroundWithBlock:Lounges Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _loungesbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportClub"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                
                if (error){
                    message = [NSString stringWithFormat: @"AirportClubs:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportClubs:findObjectsInBackgroundWithBlock:Clubs Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _clubsbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        query = [PFQuery queryWithClassName:@"AirportHotels"];
        
        if (query){
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                
                if (error){
                    message = [NSString stringWithFormat: @"AirportHotels:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportHotels:findObjectsInBackgroundWithBlock:Hotels Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _hotelbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
        
        query = [PFQuery queryWithClassName:@"AirportLuggage"];
        
        if (query){

            query.cachePolicy = kPFCachePolicyIgnoreCache;//kPFCachePolicyCacheElseNetwork;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                NSString *message= @"";
                
                if (error){
                    message = [NSString stringWithFormat: @"AirportLuggage:findObjectsInBackgroundWithBlock:Error->%@",error.description ];
                }else{
                    message = [NSString stringWithFormat: @"AirportLuggage:findObjectsInBackgroundWithBlock:Hotels Image Count->%lu",(unsigned long)objects.count ];
                    if (objects){
                        _groundbackgrounds = objects;
                    }
                    
                }
                NSLog(@"%@",message);
            }];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
        query = nil;
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
