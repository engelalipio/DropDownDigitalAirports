//
//  Airport.m
//
//  Created by Engel Alipio on 2/14/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Airport.h"


NSString *const kAirportStateCode = @"stateCode";
NSString *const kAirportTimeZoneRegionName = @"timeZoneRegionName";
NSString *const kAirportCountryName = @"countryName";
NSString *const kAirportLocalTime = @"localTime";
NSString *const kAirportActive = @"active";
NSString *const kAirportUtcOffsetHours = @"utcOffsetHours";
NSString *const kAirportCountryCode = @"countryCode";
NSString *const kAirportFaa = @"faa";
NSString *const kAirportIata = @"iata";
NSString *const kAirportElevationFeet = @"elevationFeet";
NSString *const kAirportLatitude = @"latitude";
NSString *const kAirportCity = @"city";
NSString *const kAirportFs = @"fs";
NSString *const kAirportDelayIndexUrl = @"delayIndexUrl";
NSString *const kAirportRegionName = @"regionName";
NSString *const kAirportName = @"name";
NSString *const kAirportWeatherUrl = @"weatherUrl";
NSString *const kAirportWeatherZone = @"weatherZone";
NSString *const kAirportLongitude = @"longitude";
NSString *const kAirportPostalCode = @"postalCode";
NSString *const kAirportCityCode = @"cityCode";
NSString *const kAirportIcao = @"icao";
NSString *const kAirportClassification = @"classification";
NSString *const kAirportStreet1 = @"street1";


@interface Airport ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Airport

@synthesize stateCode = _stateCode;
@synthesize timeZoneRegionName = _timeZoneRegionName;
@synthesize countryName = _countryName;
@synthesize localTime = _localTime;
@synthesize active = _active;
@synthesize utcOffsetHours = _utcOffsetHours;
@synthesize countryCode = _countryCode;
@synthesize faa = _faa;
@synthesize iata = _iata;
@synthesize elevationFeet = _elevationFeet;
@synthesize latitude = _latitude;
@synthesize city = _city;
@synthesize fs = _fs;
@synthesize delayIndexUrl = _delayIndexUrl;
@synthesize regionName = _regionName;
@synthesize name = _name;
@synthesize weatherUrl = _weatherUrl;
@synthesize weatherZone = _weatherZone;
@synthesize longitude = _longitude;
@synthesize postalCode = _postalCode;
@synthesize cityCode = _cityCode;
@synthesize icao = _icao;
@synthesize classification = _classification;
@synthesize street1 = _street1;


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
            self.stateCode = [self objectOrNilForKey:kAirportStateCode fromDictionary:dict];
            self.timeZoneRegionName = [self objectOrNilForKey:kAirportTimeZoneRegionName fromDictionary:dict];
            self.countryName = [self objectOrNilForKey:kAirportCountryName fromDictionary:dict];
            self.localTime = [self objectOrNilForKey:kAirportLocalTime fromDictionary:dict];
            self.active = [[self objectOrNilForKey:kAirportActive fromDictionary:dict] boolValue];
            self.utcOffsetHours = [[self objectOrNilForKey:kAirportUtcOffsetHours fromDictionary:dict] doubleValue];
            self.countryCode = [self objectOrNilForKey:kAirportCountryCode fromDictionary:dict];
            self.faa = [self objectOrNilForKey:kAirportFaa fromDictionary:dict];
            self.iata = [self objectOrNilForKey:kAirportIata fromDictionary:dict];
            self.elevationFeet = [[self objectOrNilForKey:kAirportElevationFeet fromDictionary:dict] doubleValue];
            self.latitude = [[self objectOrNilForKey:kAirportLatitude fromDictionary:dict] doubleValue];
            self.city = [self objectOrNilForKey:kAirportCity fromDictionary:dict];
            self.fs = [self objectOrNilForKey:kAirportFs fromDictionary:dict];
            self.delayIndexUrl = [self objectOrNilForKey:kAirportDelayIndexUrl fromDictionary:dict];
            self.regionName = [self objectOrNilForKey:kAirportRegionName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kAirportName fromDictionary:dict];
            self.weatherUrl = [self objectOrNilForKey:kAirportWeatherUrl fromDictionary:dict];
            self.weatherZone = [self objectOrNilForKey:kAirportWeatherZone fromDictionary:dict];
            self.longitude = [[self objectOrNilForKey:kAirportLongitude fromDictionary:dict] doubleValue];
            self.postalCode = [self objectOrNilForKey:kAirportPostalCode fromDictionary:dict];
            self.cityCode = [self objectOrNilForKey:kAirportCityCode fromDictionary:dict];
            self.icao = [self objectOrNilForKey:kAirportIcao fromDictionary:dict];
            self.classification = [[self objectOrNilForKey:kAirportClassification fromDictionary:dict] doubleValue];
            self.street1 = [self objectOrNilForKey:kAirportStreet1 fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stateCode forKey:kAirportStateCode];
    [mutableDict setValue:self.timeZoneRegionName forKey:kAirportTimeZoneRegionName];
    [mutableDict setValue:self.countryName forKey:kAirportCountryName];
    [mutableDict setValue:self.localTime forKey:kAirportLocalTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.active] forKey:kAirportActive];
    [mutableDict setValue:[NSNumber numberWithDouble:self.utcOffsetHours] forKey:kAirportUtcOffsetHours];
    [mutableDict setValue:self.countryCode forKey:kAirportCountryCode];
    [mutableDict setValue:self.faa forKey:kAirportFaa];
    [mutableDict setValue:self.iata forKey:kAirportIata];
    [mutableDict setValue:[NSNumber numberWithDouble:self.elevationFeet] forKey:kAirportElevationFeet];
    [mutableDict setValue:[NSNumber numberWithDouble:self.latitude] forKey:kAirportLatitude];
    [mutableDict setValue:self.city forKey:kAirportCity];
    [mutableDict setValue:self.fs forKey:kAirportFs];
    [mutableDict setValue:self.delayIndexUrl forKey:kAirportDelayIndexUrl];
    [mutableDict setValue:self.regionName forKey:kAirportRegionName];
    [mutableDict setValue:self.name forKey:kAirportName];
    [mutableDict setValue:self.weatherUrl forKey:kAirportWeatherUrl];
    [mutableDict setValue:self.weatherZone forKey:kAirportWeatherZone];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longitude] forKey:kAirportLongitude];
    [mutableDict setValue:self.postalCode forKey:kAirportPostalCode];
    [mutableDict setValue:self.cityCode forKey:kAirportCityCode];
    [mutableDict setValue:self.icao forKey:kAirportIcao];
    [mutableDict setValue:[NSNumber numberWithDouble:self.classification] forKey:kAirportClassification];
    [mutableDict setValue:self.street1 forKey:kAirportStreet1];

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

    self.stateCode = [aDecoder decodeObjectForKey:kAirportStateCode];
    self.timeZoneRegionName = [aDecoder decodeObjectForKey:kAirportTimeZoneRegionName];
    self.countryName = [aDecoder decodeObjectForKey:kAirportCountryName];
    self.localTime = [aDecoder decodeObjectForKey:kAirportLocalTime];
    self.active = [aDecoder decodeBoolForKey:kAirportActive];
    self.utcOffsetHours = [aDecoder decodeDoubleForKey:kAirportUtcOffsetHours];
    self.countryCode = [aDecoder decodeObjectForKey:kAirportCountryCode];
    self.faa = [aDecoder decodeObjectForKey:kAirportFaa];
    self.iata = [aDecoder decodeObjectForKey:kAirportIata];
    self.elevationFeet = [aDecoder decodeDoubleForKey:kAirportElevationFeet];
    self.latitude = [aDecoder decodeDoubleForKey:kAirportLatitude];
    self.city = [aDecoder decodeObjectForKey:kAirportCity];
    self.fs = [aDecoder decodeObjectForKey:kAirportFs];
    self.delayIndexUrl = [aDecoder decodeObjectForKey:kAirportDelayIndexUrl];
    self.regionName = [aDecoder decodeObjectForKey:kAirportRegionName];
    self.name = [aDecoder decodeObjectForKey:kAirportName];
    self.weatherUrl = [aDecoder decodeObjectForKey:kAirportWeatherUrl];
    self.weatherZone = [aDecoder decodeObjectForKey:kAirportWeatherZone];
    self.longitude = [aDecoder decodeDoubleForKey:kAirportLongitude];
    self.postalCode = [aDecoder decodeObjectForKey:kAirportPostalCode];
    self.cityCode = [aDecoder decodeObjectForKey:kAirportCityCode];
    self.icao = [aDecoder decodeObjectForKey:kAirportIcao];
    self.classification = [aDecoder decodeDoubleForKey:kAirportClassification];
    self.street1 = [aDecoder decodeObjectForKey:kAirportStreet1];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stateCode forKey:kAirportStateCode];
    [aCoder encodeObject:_timeZoneRegionName forKey:kAirportTimeZoneRegionName];
    [aCoder encodeObject:_countryName forKey:kAirportCountryName];
    [aCoder encodeObject:_localTime forKey:kAirportLocalTime];
    [aCoder encodeBool:_active forKey:kAirportActive];
    [aCoder encodeDouble:_utcOffsetHours forKey:kAirportUtcOffsetHours];
    [aCoder encodeObject:_countryCode forKey:kAirportCountryCode];
    [aCoder encodeObject:_faa forKey:kAirportFaa];
    [aCoder encodeObject:_iata forKey:kAirportIata];
    [aCoder encodeDouble:_elevationFeet forKey:kAirportElevationFeet];
    [aCoder encodeDouble:_latitude forKey:kAirportLatitude];
    [aCoder encodeObject:_city forKey:kAirportCity];
    [aCoder encodeObject:_fs forKey:kAirportFs];
    [aCoder encodeObject:_delayIndexUrl forKey:kAirportDelayIndexUrl];
    [aCoder encodeObject:_regionName forKey:kAirportRegionName];
    [aCoder encodeObject:_name forKey:kAirportName];
    [aCoder encodeObject:_weatherUrl forKey:kAirportWeatherUrl];
    [aCoder encodeObject:_weatherZone forKey:kAirportWeatherZone];
    [aCoder encodeDouble:_longitude forKey:kAirportLongitude];
    [aCoder encodeObject:_postalCode forKey:kAirportPostalCode];
    [aCoder encodeObject:_cityCode forKey:kAirportCityCode];
    [aCoder encodeObject:_icao forKey:kAirportIcao];
    [aCoder encodeDouble:_classification forKey:kAirportClassification];
    [aCoder encodeObject:_street1 forKey:kAirportStreet1];
}

- (id)copyWithZone:(NSZone *)zone
{
    Airport *copy = [[Airport alloc] init];
    
    if (copy) {

        copy.stateCode = [self.stateCode copyWithZone:zone];
        copy.timeZoneRegionName = [self.timeZoneRegionName copyWithZone:zone];
        copy.countryName = [self.countryName copyWithZone:zone];
        copy.localTime = [self.localTime copyWithZone:zone];
        copy.active = self.active;
        copy.utcOffsetHours = self.utcOffsetHours;
        copy.countryCode = [self.countryCode copyWithZone:zone];
        copy.faa = [self.faa copyWithZone:zone];
        copy.iata = [self.iata copyWithZone:zone];
        copy.elevationFeet = self.elevationFeet;
        copy.latitude = self.latitude;
        copy.city = [self.city copyWithZone:zone];
        copy.fs = [self.fs copyWithZone:zone];
        copy.delayIndexUrl = [self.delayIndexUrl copyWithZone:zone];
        copy.regionName = [self.regionName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.weatherUrl = [self.weatherUrl copyWithZone:zone];
        copy.weatherZone = [self.weatherZone copyWithZone:zone];
        copy.longitude = self.longitude;
        copy.postalCode = [self.postalCode copyWithZone:zone];
        copy.cityCode = [self.cityCode copyWithZone:zone];
        copy.icao = [self.icao copyWithZone:zone];
        copy.classification = self.classification;
        copy.street1 = [self.street1 copyWithZone:zone];
    }
    
    return copy;
}


@end
