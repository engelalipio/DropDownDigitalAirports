//
//  FidsData.h
//
//  Created by Engel Alipio on 5/24/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"


@interface FidsData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *airlineName;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSString *airlineLogoUrlPng;
@property (nonatomic, strong) NSString *gate;
@property (nonatomic, strong) NSString *terminal;
@property (nonatomic, strong) NSString *baggage;
@property (nonatomic, strong) NSString *destinationFamiliarName;
@property (nonatomic, strong) NSString *flightNumber;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *temperatureF;
@property (nonatomic, strong) NSString *remarksCode;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
 


- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
