//
//  Utilities.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/15.
//  Copyright © 2015 Digital World International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject



+(UIView*)    getSpecialTitleView: (UIView*) existingTitleView andNewTitle: (NSString*) anyTitle;

+(UIView*)    getSpecialTitleViewImage: (UIView*) existingTitleView andNewImage: (UIImage *) anyImage;

+(UIImage *) imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;

+(UIImage*)  getParseImage:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex;

+(void) setParseImageCell:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UITableViewCell *) anyRow;

+(void) setParseImageViewl:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UIImageView *) anyView;
@end

