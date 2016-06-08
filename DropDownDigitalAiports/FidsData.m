//
//  FidsData.m
//
//  Created by Engel Alipio on 5/24/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "FidsData.h"


NSString *const kFidsDataCity = @"city";
NSString *const kFidsDataRemarks = @"remarks";
NSString *const kFidsDataAirlineName = @"airlineName";
NSString *const kFidsDataCurrentTime = @"currentTime";
NSString *const kFidsDataAirlineLogoUrlPng = @"airlineLogoUrlPng";
NSString *const kFidsDataGate = @"gate";
NSString *const kFidsDataFlightNumber = @"flightNumber";
NSString *const kFidsDataWeather = @"weather";
NSString *const kFidsDataTemperatureF = @"temperatureF";
NSString *const kFidsDataTerminal = @"terminal";
NSString *const kFidsDataBaggage = @"baggage";
NSString *const kFidsDataDestinationFamiliarName = @"destinationFamiliarName";
NSString *const kFidsDataRemarksCode = @"remarksCode";


@interface FidsData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FidsData

@synthesize city = _city;
@synthesize remarks = _remarks;
@synthesize airlineName = _airlineName;
@synthesize currentTime = _currentTime;
@synthesize airlineLogoUrlPng = _airlineLogoUrlPng;
@synthesize gate = _gate;
@synthesize flightNumber = _flightNumber;
@synthesize weather = _weather;
@synthesize terminal = _terminal;
@synthesize baggage = _baggage;
@synthesize destinationFamiliarName = _destinationFamiliarName;
@synthesize remarksCode = _remarksCode;
@synthesize temperatureF = _temperatureF;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.city = [self objectOrNilForKey:kFidsDataCity fromDictionary:dict];
            self.remarks = [self objectOrNilForKey:kFidsDataRemarks fromDictionary:dict];
            self.airlineName = [self objectOrNilForKey:kFidsDataAirlineName fromDictionary:dict];
            self.currentTime = [self objectOrNilForKey:kFidsDataCurrentTime fromDictionary:dict];
            self.airlineLogoUrlPng = [self objectOrNilForKey:kFidsDataAirlineLogoUrlPng fromDictionary:dict];
            self.gate = [self objectOrNilForKey:kFidsDataGate fromDictionary:dict];
            self.flightNumber = [self objectOrNilForKey:kFidsDataFlightNumber fromDictionary:dict];
            self.weather = [self objectOrNilForKey:kFidsDataWeather fromDictionary:dict];
            self.temperatureF = [self objectOrNilForKey:kFidsDataTemperatureF fromDictionary:dict];
            self.terminal = [self objectOrNilForKey:kFidsDataTerminal fromDictionary:dict];
            self.baggage = [self objectOrNilForKey:kFidsDataBaggage fromDictionary:dict];
            self.destinationFamiliarName = [self objectOrNilForKey:kFidsDataDestinationFamiliarName fromDictionary:dict];
            self.remarksCode = [self objectOrNilForKey:kFidsDataRemarksCode fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.city forKey:kFidsDataCity];
    [mutableDict setValue:self.remarks forKey:kFidsDataRemarks];
    [mutableDict setValue:self.airlineName forKey:kFidsDataAirlineName];
    [mutableDict setValue:self.currentTime forKey:kFidsDataCurrentTime];
    [mutableDict setValue:self.airlineLogoUrlPng forKey:kFidsDataAirlineLogoUrlPng];
    [mutableDict setValue:self.gate forKey:kFidsDataGate];
    [mutableDict setValue:self.flightNumber forKey:kFidsDataFlightNumber];
    [mutableDict setValue:self.weather forKey:kFidsDataWeather];
    [mutableDict setValue:self.temperatureF forKey:kFidsDataTemperatureF];
    [mutableDict setValue:self.terminal forKey:kFidsDataTerminal];
    [mutableDict setValue:self.baggage forKey:kFidsDataBaggage];
    [mutableDict setValue:self.destinationFamiliarName forKey:kFidsDataDestinationFamiliarName];
    [mutableDict setValue:self.remarksCode forKey:kFidsDataRemarksCode];
 
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.city = [aDecoder decodeObjectForKey:kFidsDataCity];
    self.remarks = [aDecoder decodeObjectForKey:kFidsDataRemarks];
    self.airlineName = [aDecoder decodeObjectForKey:kFidsDataAirlineName];
    self.currentTime = [aDecoder decodeObjectForKey:kFidsDataCurrentTime];
    self.airlineLogoUrlPng = [aDecoder decodeObjectForKey:kFidsDataAirlineLogoUrlPng];
    self.gate = [aDecoder decodeObjectForKey:kFidsDataGate];
    self.flightNumber = [aDecoder decodeObjectForKey:kFidsDataFlightNumber];
    self.weather = [aDecoder decodeObjectForKey:kFidsDataWeather];
    self.temperatureF = [aDecoder decodeObjectForKey:kFidsDataTemperatureF];
    self.terminal = [aDecoder decodeObjectForKey:kFidsDataTerminal];
    self.baggage = [aDecoder decodeObjectForKey:kFidsDataBaggage];
    self.destinationFamiliarName = [aDecoder decodeObjectForKey:kFidsDataDestinationFamiliarName];
    self.remarksCode = [aDecoder decodeObjectForKey:kFidsDataRemarksCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_city forKey:kFidsDataCity];
    [aCoder encodeObject:_remarks forKey:kFidsDataRemarks];
    [aCoder encodeObject:_remarksCode forKey:kFidsDataRemarksCode];
    [aCoder encodeObject:_airlineName forKey:kFidsDataAirlineName];
    [aCoder encodeObject:_currentTime forKey:kFidsDataCurrentTime];
    [aCoder encodeObject:_airlineLogoUrlPng forKey:kFidsDataAirlineLogoUrlPng];
    [aCoder encodeObject:_gate forKey:kFidsDataGate];
    [aCoder encodeObject:_flightNumber forKey:kFidsDataFlightNumber];
    [aCoder encodeObject:_weather forKey:kFidsDataWeather];
    [aCoder encodeObject:_temperatureF forKey:kFidsDataTemperatureF];
    [aCoder encodeObject:_terminal forKey:kFidsDataTerminal];
    [aCoder encodeObject:_baggage forKey:kFidsDataBaggage];
    [aCoder encodeObject:_destinationFamiliarName forKey:kFidsDataDestinationFamiliarName];
}

- (id)copyWithZone:(NSZone *)zone
{
    FidsData *copy = [[FidsData alloc] init];
    
    if (copy) {

        copy.city = [self.city copyWithZone:zone];
        copy.remarks = [self.remarks copyWithZone:zone];
        copy.remarksCode= [self.remarksCode copyWithZone:zone];
        copy.airlineName = [self.airlineName copyWithZone:zone];
        copy.currentTime = [self.currentTime copyWithZone:zone];
        copy.airlineLogoUrlPng = [self.airlineLogoUrlPng copyWithZone:zone];
        copy.gate = [self.gate copyWithZone:zone];
        copy.flightNumber = [self.flightNumber copyWithZone:zone];
        copy.weather = [self.weather copyWithZone:zone];
        copy.temperatureF = [self.temperatureF copyWithZone:zone];
        copy.terminal = [self.terminal copyWithZone:zone];
        copy.baggage = [self.baggage copyWithZone:zone];
        copy.destinationFamiliarName = [self.destinationFamiliarName copyWithZone:zone];
    }
    
    return copy;
}


@end
