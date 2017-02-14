//
//  Airport.h
//
//  Created by Engel Alipio on 2/14/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"


@interface Airport : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *timeZoneRegionName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *localTime;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) double utcOffsetHours;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *faa;
@property (nonatomic, strong) NSString *iata;
@property (nonatomic, assign) double elevationFeet;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *fs;
@property (nonatomic, strong) NSString *delayIndexUrl;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *weatherUrl;
@property (nonatomic, strong) NSString *weatherZone;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *icao;
@property (nonatomic, assign) double classification;
@property (nonatomic, strong) NSString *street1;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
