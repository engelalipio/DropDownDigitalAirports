//
//  Utilities.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/15.
//  Copyright © 2015 Digital World International. All rights reserved.
//


#import "Utilities.h"

@implementation Utilities

+(void) setParseImageViewl:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UIImageView *) anyView{
    PFObject *imageObject = nil;
    NSString  *message       = @"";
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            PFFile *file = [imageObject objectForKey:@"Image"];
            NSString *imageName = [imageObject objectForKey:@"ImageName"];
            NSLog(@"Setting getParseImage -> %@ to ImageView", imageName);
            if (file){
                
                [file getDataInBackgroundWithBlock:^(NSData*data, NSError* error){
                    if (data){
                        UIImage *cellImage  = [UIImage imageWithData:data];
                        if (cellImage){
                            [anyView setImage:cellImage];
                        }
                    }
                }];
                
            }
        }
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        imageObject = nil;
    }
    

}



+(void) setParseImageCell:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UITableViewCell *) anyRow{
    
    
    PFObject *imageObject = nil;
    NSString  *message       = @"";
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            PFFile *file = [imageObject objectForKey:@"Image"];
            NSString *imageName = [imageObject objectForKey:@"ImageName"];
            NSLog(@"Setting getParseImage -> %@ to TableViewCell", imageName);
            if (file){
                
                [file getDataInBackgroundWithBlock:^(NSData*data, NSError* error){
                    if (data){
                        UIImage *cellImage  = [UIImage imageWithData:data];
                        if (cellImage){
                            //cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(120,anyRow.frame.size.height)];
                            if (anyRow.imageView.image){
                                [anyRow.imageView setImage:cellImage];
                            }else{
                                
                                UIImageView* imgView = nil;
                                for (int idx = 0; idx < anyRow.contentView.subviews.count ; idx++){
                                    UIView *subView =   [anyRow.contentView.subviews objectAtIndex:idx];
                                    if ([subView isKindOfClass:[UIImageView class]]){
                                        imgView = (UIImageView*) subView;
                                        if (imgView){
                                            [imgView setImage:cellImage];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }];
                
            }
        }
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        imageObject = nil;
    }
    
    
}

+(UIImage*) getParseImage:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex{
    

    PFObject *imageObject = nil;
    NSString  *message       = @"";
    UIImage *cellImage  = nil;
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            PFFile *file = [imageObject objectForKey:@"Image"];
            NSString *imageName = [imageObject objectForKey:@"ImageName"];
            NSLog(@"Retrieving getParseImage %@ ...", imageName);
            if (file){
                
                NSData *imageData = [file getData ];
                     
                     if (imageData){
                         
                          cellImage = [UIImage imageWithData:imageData ];

                     }
            }
       }
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        imageObject = nil;
    }
    return  cellImage;
 
}

+(UIView*) getSpecialTitleViewImage: (UIView*) existingTitleView andNewImage: (UIImage *) anyImage{
    UIImageView *imageView = nil;
    NSString *message = @"";
    @try {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, anyImage.size.width ,anyImage.size.height)];
        //  [imageView.layer setBorderColor:[UIColor blackColor].CGColor];
        //  [imageView.layer setBorderWidth:1.0f];
        [imageView setImage:anyImage];
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    return imageView;
}

+(UIView*) getSpecialTitleView: (UIView*) existingTitleView andNewTitle: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, existingTitleView.frame.size.width , 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:kTitleColor];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:kTitleFont size:kTitleSize]];
        [titleView setText:anyTitle];
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    return titleView;
}

+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    UIImage* newImage = nil;
    CGFloat scale = 0;
    NSString *message  = @"";
    @try {
        
        scale = [[UIScreen mainScreen]scale];
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
        [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        message = @"";
    }
    
    return newImage;
}

@end
