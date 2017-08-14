//
//  Utilities.m
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 10/22/15.
//  Copyright © 2015 Digital World International. All rights reserved.
//


#import "Utilities.h"
#import "AppDelegate.h"

@implementation Utilities
 

+(void) setParseImageView:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UIImageView *) anyView{
    
    NSDictionary *imageObject = nil;
    NSString     *message     = @"",
    *rootPath    = @"",
    *imageName   = @"";
    
    AZSCloudBlobContainer *container = nil;
    
    AZSCloudBlob *menuBlob = nil;
    
    AppDelegate *appDelegate = nil;
    
    
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            
            appDelegate = [AppDelegate currentDelegate];
            
            container = [appDelegate.storageClient containerReferenceFromName:kAzureStorageURL];
            
            menuBlob = [container blockBlobReferenceFromName:kAzureStorageAirport];
            
            rootPath = [imageObject objectForKey:@"RootPath"];
            
            imageName = [imageObject objectForKey:@"ImageURL"];
            
            
            message = [NSString stringWithFormat:@"%@%@%@",kAzureStorageURL,rootPath,imageName];
            
            
            NSLog(@"setParseImageView->setting Azure Storage Image -> %@ to UIImageView", imageName);
            if (message){
                
                NSURL *imageURL = [[NSURL alloc] initWithString:message];
                
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image){
                    
                    
                    if (anyView){
                        
                        [anyView setImage:image];
                        
                    }
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
    
    
}


+(NSString*) getParseColumnValue:(NSArray *) imageSourceArray  anyIndex:(NSInteger) imageIndex anyColumn:(NSString *) columnName{
    PFObject *imageObject = nil;
    NSString  *message       = @"";
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            
            message = [imageObject objectForKey:columnName];
            NSLog(@"Getting ColumnValue -> %@  ", columnName);
        }
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        
        imageObject = nil;
    }
    return message;
}


+(void) setParseImageCell:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex tableCell:(UITableViewCell *) anyRow{
    
    
    NSDictionary *imageObject = nil;
    
    NSString     *message     = @"",
    *rootPath    = @"",
    *imageName   = @"";
    
    AZSCloudBlobContainer *container = nil;
    
    AZSCloudBlob *menuBlob = nil;
    
    AppDelegate *appDelegate = nil;
    
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            
            appDelegate = [AppDelegate currentDelegate];
            
            container = [appDelegate.storageClient containerReferenceFromName:kAzureStorageURL];
            
            menuBlob = [container blockBlobReferenceFromName:kAzureStorageAirport];
            
            
            rootPath = [imageObject objectForKey:@"RootPath"];
            
            imageName = [imageObject objectForKey:@"ImageURL"];
            
            message = [NSString stringWithFormat:@"%@%@%@",kAzureStorageURL,rootPath,imageName];
            
            
            NSLog(@"setParseImageCell->setting Azure Storage Image -> %@ to UITableViewCell", imageName);
            if (message){
                
                
                NSURL *imageURL = [[NSURL alloc] initWithString:message];
                
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image){
                    
                    if (image){
                        //image = [Utilities imageResize:image andResizeTo:CGSizeMake(120,anyRow.frame.size.height)];
                        
                        if (anyRow.imageView.image){
                            [anyRow.imageView setImage:image];
                        }else{
                            
                            UIImageView* imgView = nil;
                            
                            for (int idx = 0; idx < anyRow.contentView.subviews.count ; idx++){
                                UIView *subView =   [anyRow.contentView.subviews objectAtIndex:idx];
                                //For Image
                                if ([subView isKindOfClass:[UIImageView class]]){
                                    imgView = (UIImageView*) subView;
                                    if (imgView){
                                        [imgView setImage:image];
                                        break;
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
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
        container = nil;
        menuBlob = nil;
    }
    
}

+(UIImage*) getAzureStorageImage:(NSArray *) imageSourceArray anyIndex:(NSInteger) imageIndex{
    
    NSDictionary *imageObject = nil;
    NSString     *message     = @"",
                 *rootPath    = @"",
                 *imageName   = @"";
    
    AZSCloudBlobContainer *container = nil;
    
    AZSCloudBlob *menuBlob = nil;
    
    AppDelegate *appDelegate = nil;
    
    
    UIImage *cellImage = nil;
    
    @try {
        
        imageObject = [imageSourceArray objectAtIndex:imageIndex];
        
        if (imageObject){
            
            appDelegate = [AppDelegate currentDelegate];
            
            container = [appDelegate.storageClient containerReferenceFromName:kAzureStorageURL];
            
            menuBlob = [container blockBlobReferenceFromName:kAzureStorageAirport];
            
            rootPath = [imageObject objectForKey:@"RootPath"];
            
            imageName = [imageObject objectForKey:@"ImageURL"];
            
            
            message = [NSString stringWithFormat:@"%@%@%@",kAzureStorageURL,rootPath,imageName];
            
            
            NSLog(@"getAzureStorageImage-> %@", imageName);
            if (message){
                
                NSURL *imageURL = [[NSURL alloc] initWithString:message];
                
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image){
                    
                    cellImage = image;
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
