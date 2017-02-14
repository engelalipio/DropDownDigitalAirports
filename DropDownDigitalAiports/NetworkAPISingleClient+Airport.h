//
//  NetworkAPISingleClient.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 5/24/16.
//  Copyright © 2016 Digital World International. All rights reserved.
//

/*
 
 #define kFlightStatsAirportBaseURL @"https://api.flightstats.com/flex/airports/rest/v1/json/"
 #define kFlightStatsAirportInfoURI @"{airport}/today"
 
 */

#import "NetworkAPISingleClient.h"

@interface NetworkAPISingleClient (Airport)

+ (AFJSONRequestOperation *)retrieveAirportInfo:(NSString *)maxCount
                         completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock;


@end
