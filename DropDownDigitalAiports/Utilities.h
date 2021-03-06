//
//  Utilities.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/15.
//  Copyright © 2015 Digital World International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString*) getParseColumnValue:(NSArray *) imageSourceArray  anyIndex:(NSInteger) imageIndex anyColumn:(NSString *) columnName;

+(UIView*)    getSpecialTitleView: (UIView*) existingTitleView andNewTitle: (NSString*) anyTitle;

+(UIView*)    getSpecialTitleViewImage: (UIView*) existingTitleView andNewImage: (UIImage *) anyImage;

+(UIImage *) imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;

+(UIImage*)  getAzureStorageImage:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex;

+(void) setParseImageCell:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UITableViewCell *) anyRow;

+(void) setParseImageView:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UIImageView *) anyView;
@end

