//
//  BaseClass.m
//
//  Created by Engel Alipio on 5/24/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BaseClass.h"
#import "FidsData.h"


NSString *const kBaseClassFidsData = @"fidsData";


@interface BaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize fidsData = _fidsData;


+ (NSDictionary *)mapping{
    
    
    NSDictionary *map = [[NSDictionary alloc] initWithObjectsAndKeys:
                         kBaseClassFidsData,@"fidsData",
                         nil];
    
    return map;
}

+ (NSString *)key{
    return nil;
}


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
    NSObject *receivedFidsData = [dict objectForKey:kBaseClassFidsData];
    NSMutableArray *parsedFidsData = [NSMutableArray array];
    if ([receivedFidsData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedFidsData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedFidsData addObject:[FidsData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedFidsData isKindOfClass:[NSDictionary class]]) {
       [parsedFidsData addObject:[FidsData modelObjectWithDictionary:(NSDictionary *)receivedFidsData]];
    }

    self.fidsData = [NSArray arrayWithArray:parsedFidsData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForFidsData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.fidsData) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFidsData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFidsData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFidsData] forKey:kBaseClassFidsData];

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

    self.fidsData = [aDecoder decodeObjectForKey:kBaseClassFidsData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_fidsData forKey:kBaseClassFidsData];
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseClass *copy = [[BaseClass alloc] init];
    
    if (copy) {

        copy.fidsData = [self.fidsData copyWithZone:zone];
    }
    
    return copy;
}


@end
