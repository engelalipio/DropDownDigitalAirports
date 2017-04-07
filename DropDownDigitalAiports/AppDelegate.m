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
#import "NetworkAPISingleClient+Airport.h"
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
@synthesize sightseeingbackgrounds = _sightseeingbackgrounds;
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
@synthesize currentBuildInfo = _currentBuildInfo;
@synthesize hostReachability = _hostReachability;
@synthesize internetReachability = _internetReachability;
@synthesize connectionImageName = _connectionImageName;
@synthesize storageClient = _storageClient;
@synthesize azureClient = _azureClient;
@synthesize airportCode = _airportCode;

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

-(void) retrieveAirportInfo{
    
 
    [NetworkAPISingleClient retrieveAirportInfo:kFlightStatsMaxCount completionBlock:^(NSArray *arrData) {
        
        if (arrData){
            
            BaseClass *baseFids =  (BaseClass*) [arrData firstObject];
            
            if (baseFids){
                
                NSDictionary *currentAirport = (NSDictionary*) [baseFids airport];
                
                
                if (currentAirport){
                    
                    
                    Airport *airport = [[Airport alloc] initWithDictionary:currentAirport];
                    
                    _restaurantName      = [airport name];;
                    
                    
                    if (airport.street1){
                        _restaurantAddress   = [airport street1];
                    }
                    
                    if (airport.city){
                        _restaurantCity      = [airport city];
                    }
                    
                    if (airport.stateCode){
                        _restaurantState      =  [airport stateCode];
                    }
                    
                    if (airport.postalCode){
                        _restaurantZip       =  [airport postalCode];
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

-(void) retrieveAirportFIDSArrivals{
    
    [NetworkAPISingleClient retrieveArrivals:kFlightStatsMaxCount completionBlock:^(NSArray *arrData) {
        
        if (arrData){
            [MSAnalytics trackEvent:@"retrieveAirportFIDSArrivals"];
            BaseClass *baseFids =  (BaseClass*) [arrData firstObject];
            
            if (baseFids){
                
                NSArray *arrivalsArray = [baseFids fidsData];
                NSMutableArray   *airlinesArray = [[NSMutableArray alloc] init];
                
                if (arrivalsArray){
                    
                    _arrivals = [[NSMutableDictionary alloc] initWithCapacity:arrivalsArray.count];
                    
                    if (arrivalsArray.count == 0){

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
                    if (! self.useAPI){
                        [_departures setValue:arrivalsArray forKey:@"Departures"];
                    }
                    
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
            [MSAnalytics trackEvent:@"retrieveAirportFIDSDepartures"];
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

-(void) initReachabilityCheck{
    
    NSString *remoteHostName =  @"";
    
    @try {
        
        /*
         Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        //Change the host name here to change the server you want to monitor.
         remoteHostName = kDDDM;
 
        
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        [self updateInterfaceWithReachability:self.hostReachability];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Error ->%@",exception.description);
    } @finally {
        remoteHostName = @"";
    }


    
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
 
    
    if (reachability == self.internetReachability)
    {
        [self reachableTest:reachability];
    }
    
}


- (void)reachableTest:(Reachability *) reachObject{
    
    UIAlertController *alert = nil;
    UIAlertAction *okAction = nil;
      NSString *statusString = @"",
               *imageName = @"";
    
    @try {
        
        
        NetworkStatus netStatus = [reachObject currentReachabilityStatus];
        BOOL connectionRequired = [reachObject connectionRequired];
        
      
        
        switch (netStatus)
        {
            case NotReachable:
            {
                statusString = NSLocalizedString(@"Internet Access Not Available",@"");
                
                /*
                 Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
                 */
                connectionRequired = NO;
                imageName = @"stop-32.png";

                break;
            }
                
            case ReachableViaWWAN:        {
                statusString = NSLocalizedString(@"Reachable via WWAN", @"");
                imageName = @"WWAN5.png";
                
                break;
            }
            case ReachableViaWiFi:        {
                statusString= NSLocalizedString(@"Reachable via WiFi", @"");
                imageName = @"Airport.png";
                break;
            }
        }
        
       
            alert = [UIAlertController alertControllerWithTitle:@"Internet Connectivity Status"
                                                        message:statusString
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:nil];
            
            [alert addAction:okAction];
                    _connectionImageName = imageName;
       /* if (! _connectionImageName){

            [self.window.rootViewController presentViewController:alert animated:YES completion:^(void){
                
            }];
        }*/
       
        
        
    } @catch (NSException *exception) {
        NSLog(@"notReachableAction:Error->%@",exception.description);
    } @finally {
        alert = nil;
        okAction = nil;
    }
}


-(void) initMobileCenter{
    [MSMobileCenter start:kMobileCenterKey withServices:@[[MSAnalytics class],[MSCrashes class]]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _language = @"English";
    _isDynamic = YES;
    _isSent   = NO;
    _isiPhone = NO;
    _useAPI = NO;
    _restaurantTable     = @"Welcome To DropDownDigitalMenus.Com\n Proudly Serving All Airports";
    _restaurantName      = @"Baltimore/Washington International Thurgood Marshall Airport";
    _restaurantAddress   = @"7050 Friendship Road BWI Airport";
    _restaurantCity      = @"Maryland";
    _restaurantState     = @"MD";
    _restaurantZip       = @"21240-0766";
    _interval            = 5;
    
    
    if (! self.airportCode){
        _airportCode = kFlightStatsAirport;
    }

    [self initReachabilityCheck];
    [self extractCurrentBuildInformation];
    [self initLocationServices];
    [self initAzureStorage];
    [self initMobileCenter];
    [self prepareAirportbackgrounds];
    [self retrieveAirportInfo];
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

-(void) extractCurrentBuildInformation{
    
    NSString *appVersionString = @"",
             *appBuildString = @"",
             *versionBuildString = @"";
    
    @try {
        
         appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
         appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        
         versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
        
        if (versionBuildString){
            _currentBuildInfo = versionBuildString;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        
    } @finally {
         appVersionString = @"";
         appBuildString = @"";
         versionBuildString = @"";
    }
}

-(void) initLocationServices{
    
    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager setDelegate:self];
    
}

-(void) initAzureStorage{
    
    
    NSString *message  = @"",
             *appKey   = kParseAppId,
             *clientKey = kParseKey;
    
    AZSCloudStorageAccount *account = nil;
    
    AZSStorageCredentials *credentials = nil;
    
    NSError *err = nil;
    
    @try {
        
        
        message =  [NSString stringWithFormat:@"DefaultEndpointsProtocol=https;AccountName=%@;AccountKey=%@",kAzureStorageName,kAzureStorageKey1];
    
        
        /** AZSStorageCredentials is used to store credentials used to authenticate Storage Requests.
         
         AZSStorageCredentials can be created with a Storage account name and account key for Shared Key access,
         or with a SAS token (forthcoming.)  Sample usage with SharedKey authentication:
         
         AZSStorageCredentials *storageCredentials = [[AZSStorageCredentials alloc] initWithAccountName:<name> accountKey:<key>];
         AZSCloudStorageAccount *storageAccount = [[AZSCloudStorageAccount alloc] initWithCredentials:storageCredentials useHttps:YES];
         AZSCloudBlobClient *blobClient = [storageAccount getBlobClient];
         
         */
        
        credentials = [[AZSStorageCredentials alloc] initWithAccountName:kAzureSharedKey accountKey:kAzureStorageKey1];
        
        
        account =  [[AZSCloudStorageAccount alloc] initWithCredentials:credentials useHttps:YES error:&err];
        
        
        if (account){
            _storageClient = [account getBlobClient];
            message = [NSString  stringWithFormat:@"Successfully connected Azure Storage for %@",message];
            NSLog(@"initAzureStorage:Message->%@",message);
            
        }
        
        message = [NSString stringWithFormat:@"%@%@",kAzureTableRootURL,kAzureSharedKey];
        
        
        
        
        
    }
    @catch (NSException *exception) {
        message = [NSString stringWithFormat:@"initAzureStorage:Error->%@", exception.debugDescription];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        appKey = @"";
        clientKey = @"";
    }
    
}

-(void) prepareAirportbackgrounds{
    
    
    NSString *message = @"";
    
    NSPredicate *tableFilter = nil;
    
    MSTable *menuTable = nil;
    MSQuery *query = nil;
    
    NSString *filterFormat = @"PartitionKey == '%@'";
    
    @try {
        
        
        message = kAzureMenuTable;
        
        _azureClient = [MSClient clientWithApplicationURLString:message];
        
        /* NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:message]];
         
         NSMutableURLRequest *mRequest = [request mutableCopy];
         
         NSLocale *currentLocale = [NSLocale currentLocale];
         NSString *strDate = [[NSDate date] descriptionWithLocale:currentLocale];
         
         [mRequest addValue:@"2015-12-11" forHTTPHeaderField:@"x-ms-version"];
         [mRequest addValue:strDate forHTTPHeaderField:@"x-ms-date"];
         [mRequest addValue:@"SharedKey" forHTTPHeaderField:@"Authorization"];
         [mRequest addValue:@"eksh%2F9Q6GMUbWAlQIfcw%2BgYNlKdRcfxQ3TPgMPrhOUA%3D" forHTTPHeaderField:@"dwistore"];
         
         request = [mRequest copy];
         
         NSLog(@"%@",request.allHTTPHeaderFields);
         
         _azureClient = [MSClient clientWithApplicationURL:request.URL];*/
        
        if (_azureClient){
            message = [NSString  stringWithFormat:@"Successfully connected Azure Table for %@",message];
            NSLog(@"loadAzureStorageData:Message->%@",message);
        }
        
        
        if (_azureClient){
            menuTable =    [_azureClient tableWithName:kAzureAirportBackgroundsTableName];
            
            query = [menuTable query];
            
            
        }
        
        
        
        
        //BEGIN Backgrounds
        
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportBackgrounds"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportBackgrounds->%d",backgroundsCount];
                    _backgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        //END Backgrounds

        //BEGIN FlightBackgrounds
        
        menuTable = [self.azureClient tableWithName:kAzureAirportFlightBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"FlightBackgrounds"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:FlightBackgrounds->%d",backgroundsCount];
                    _flightbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];

            
        }
        
        //END FlightBackgrounds
        
        //BEGIN AirportDining
        
        menuTable = [self.azureClient tableWithName:kAzureAirportDiningBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportDining"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:DiningBackgrounds->%d",backgroundsCount];
                    _diningbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
         //END AirportDining
        
        
        
        //BEGIN Food Courts
        
        menuTable = [self.azureClient tableWithName:kAzureAirportFoodCourtBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportFoodCourt"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportFoodCourt->%d",backgroundsCount];
                    _foodcourtbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        //END Food Courts
        
        //BEGIN Food ToGo
        
        menuTable = [self.azureClient tableWithName:kAzureAirportFoodToGoBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportFoodToGo"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportFoodToGo->%d",backgroundsCount];
                    _foodtogobackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        //END Food ToGo
        

        //BEGIN Airport Shops
        
        menuTable = [self.azureClient tableWithName:kAzureAirportShopsBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportShops"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportShops->%d",backgroundsCount];
                    _shopsbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        
        //End Airport Shops
        
        
        //BEGIN Airport Lounges
        
        menuTable = [self.azureClient tableWithName:kAzureAirportLoungesBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportLounges"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportLounges->%d",backgroundsCount];
                    _loungesbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        
        //End Airport Lounges
        
        
        //BEGIN Airport Hotels
        
        menuTable = [self.azureClient tableWithName:kAzureAirportHotelsBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"AirportHotels"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:AirportHotels->%d",backgroundsCount];
                    _hotelbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        
        //End Airport Hotels
        
        
        
        
        
        //BEGIN Sightseeing
        
        menuTable = [self.azureClient tableWithName:kAzureSightSeeingBackgroundsTableName];
        query =  [menuTable query];
        
        if (query){
            
            tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,@"SightSeeing"]];
            
            query = [menuTable queryWithPredicate:tableFilter];
            
            [query orderByAscending:@"PartitionKey"];
            [query orderByAscending:@"RowKey"];
            
            
            [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                NSString *queryMessage = @"";
                int backgroundsCount = 0;
                if (error){
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                }else{
                    
                    backgroundsCount =  result.items.count;
                    
                    queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:SightSeeing->%d",backgroundsCount];
                    _sightseeingbackgrounds =  result.items;
                    
                    
                }
                NSLog(@"%@",queryMessage);
            }];
            
            
        }
        
        
        //End Sightseeing
        
        
        /*
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
        
 
        */
        
        
        
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
   [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


@end
