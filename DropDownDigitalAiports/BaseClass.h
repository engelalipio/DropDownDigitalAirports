//
//  BaseClass.h
//
//  Created by Engel Alipio on 5/24/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"

@class Airport;

@interface BaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *fidsData;
@property (nonatomic, strong) Airport *airport;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
