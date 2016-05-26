//
//  NetworkAPISingleClient.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 5/24/16.
//  Copyright © 2016 Digital World International. All rights reserved.
//

#import "NetworkAPISingleClient.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DataModels.h"

 


@implementation NetworkAPISingleClient(FIDS)


#pragma mark-> /v1/json/{airport}/arrivals
+ (AFJSONRequestOperation *)retrieveArrivals:(NSString *)maxCount
                             completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock{
    
    NSString    *message          = @"",
                       *servicePath     = @"";
    
    NSURL        *url  = nil;
    
    AFJSONRequestOperation *request = nil;
    
    NetworkAPISingleClient *api = nil;
    
    @try {
 
    
        servicePath =  [NSString stringWithFormat:@"%@%@?appId=%@&appKey=%@&requestedFields=%@&excludeCargoOnlyFlights=true",kFlightStatsBaseURL,kFlightStatsArrivalURI,kFligthStatsApp,kFligthStatsKey,kFlightStatsFIDSFields];
        
        servicePath = [servicePath stringByReplacingOccurrencesOfString:@"{airport}" withString:kFlightStatsAirport];
        
        NSLog(@"Invoking::retrieveArrivals::%@",servicePath);
        
        url = [[NSURL alloc] initWithString:kFlightStatsBaseURL];
        
        api =  [[NetworkAPISingleClient sharedClient] initWithBaseURL:url];
        
        request =  [api  makeGetOperationWithObjecModel:[BaseClass class]
                                                 atPath:servicePath
                                        completionBlock:completionBlock
                                          andErrorBlock:errorBlock];
        
        message = servicePath;
        
        NSLog(@"Completed::%@",message);
    }
    @catch (NSException *exception) {
        message = [exception description];
        NSLog(@"Error::%@",message);
    }
    @finally {
        message = @"";
        api = nil;
        servicePath = nil;
    }
    return request;
    
}

#pragma mark-> /v1/json/{airport}/departures
+ (AFJSONRequestOperation *)retrieveDepartures:(NSString *)maxCount
                         completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock{
    
    NSString    *message          = @"",
                       *servicePath     = @"";
    
    NSURL        *url  = nil;
    
    AFJSONRequestOperation *request = nil;
    
    NetworkAPISingleClient *api = nil;
    
    @try {
        
        
        servicePath =  [NSString stringWithFormat:@"%@%@?appId=%@&appKey=%@&requestedFields=%@&excludeCargoOnlyFlights=true",
                        kFlightStatsBaseURL,kFlightStatsDepartureURI,kFligthStatsApp,kFligthStatsKey,kFlightStatsFIDSFields];
        
        servicePath = [servicePath stringByReplacingOccurrencesOfString:@"{airport}" withString:kFlightStatsAirport];
        
        NSLog(@"Invoking::retrieveArrivals::%@",servicePath);
        
        url = [[NSURL alloc] initWithString:kFlightStatsBaseURL];
        
        api =  [[NetworkAPISingleClient sharedClient] initWithBaseURL:url];
        
        request =  [api  makeGetOperationWithObjecModel:[BaseClass class]
                                                 atPath:servicePath
                                        completionBlock:completionBlock
                                          andErrorBlock:errorBlock];
        
        message = servicePath;
        
        NSLog(@"Completed::%@",message);
    }
    @catch (NSException *exception) {
        message = [exception description];
        NSLog(@"Error::%@",message);
    }
    @finally {
        message = @"";
        api = nil;
        servicePath = nil;
    }
    return request;

    
}



@end
