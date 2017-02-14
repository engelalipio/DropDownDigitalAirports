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

 


@implementation NetworkAPISingleClient(Airport)


#pragma mark-> Airport Info

+ (AFJSONRequestOperation *)retrieveAirportInfo:(NSString *)maxCount
                             completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock{
    
    NSString    *message         = @"",
                *servicePath     = @"",
                *code            = @"";
    
    NSURL       *url  = nil;
    
    AFJSONRequestOperation *request = nil;
    
    NetworkAPISingleClient *api = nil;
    
    AppDelegate *appDelegate = nil;
    
    @try {

        
        code = kFlightStatsAirport;
        
        appDelegate = [AppDelegate currentDelegate];
        
        if (appDelegate){
            if (appDelegate.airportCode){
                code = [appDelegate airportCode];
            }
        }
        
    
        
        servicePath =  [NSString stringWithFormat:@"%@%@?appId=%@&appKey=%@",kFlightStatsAirportBaseURL,kFlightStatsAirportInfoURI,
                        kFligthStatsApp,kFligthStatsKey];
        
        servicePath = [servicePath stringByReplacingOccurrencesOfString:@"{airport}" withString:code];
        
        NSLog(@"Invoking::retrieveAirportInfo::%@",servicePath);
        
        url = [[NSURL alloc] initWithString:kFlightStatsAirportBaseURL];
        
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
