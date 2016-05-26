//
//  NetworkAPISingleClient.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 5/24/16.
//  Copyright © 2016 Digital World International. All rights reserved.
//

/*
 
 --FIDS data for flights departing from airport --> /v1/json/{airport}/departures
 --FIDS data for flights arriving at airport --> /v1/json/{airport}/arrivals
 
 */

#import "NetworkAPISingleClient.h"

@interface NetworkAPISingleClient (FIDS)

+ (AFJSONRequestOperation *)retrieveArrivals:(NSString *)maxCount
                         completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock;

+ (AFJSONRequestOperation *)retrieveDepartures:(NSString *)maxCount
                          completionBlock:(void(^) (NSArray * values))
completionBlock andErrorBlock:(void(^) (NSError *))errorBlock;

@end
