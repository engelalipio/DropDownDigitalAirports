//
//  ItemViewController.h
//  DropDownDigitalAirports
//
//  Created by Engel Alipio on 11/9/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum {
   Flight  = 0,
   Dining = 1,
   Shops     = 2,
   Lounge    = 3,
   Terminal   = 4,
   Hotel  = 5
} ServiceType;


@interface ItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *imageBorderLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIMGView;
@property (weak, nonatomic) IBOutlet UIImageView *TempIMGView;

@property (weak, nonatomic) IBOutlet UIImageView *AirlineIMGView;
@property (weak, nonatomic) IBOutlet UIImageView *ArrDepIMGView;

@property (weak, nonatomic) IBOutlet UILabel *TempValue;
@property (weak, nonatomic) IBOutlet UILabel *WeatherValue;

@property (weak, nonatomic) IBOutlet UILabel *Arrival_DepartureValue;

@property (strong, nonatomic) IBOutlet UILabel *labelDescription;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutlet UIButton *trackButton;

@property (weak, nonatomic) IBOutlet UILabel *FlightLabel;
@property (strong, nonatomic) IBOutlet UILabel *FlightValue;

@property (weak, nonatomic) IBOutlet UILabel *TerminalLabel;
@property (weak, nonatomic) IBOutlet UILabel *TerminalValue;

@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusValue;

@property (weak, nonatomic) IBOutlet UILabel *AircraftLabel;
@property (weak, nonatomic) IBOutlet UILabel *AircraftValue;

@property (assign, nonatomic) ServiceType foodType;

@property (nonatomic,strong) NSTimer   *timer;
@property (nonatomic,strong) NSRunLoop *loop;


@property (nonatomic,strong) NSArray *rndStatuses;
@property (nonatomic,strong) NSArray *rndImages;

@property (weak, nonatomic) IBOutlet UILabel  *rndLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rndImage;

- (IBAction)trackAction:(UIButton *)sender;


- (IBAction)cancelOrder:(UIButton *)sender;

-(void) configureSegs;
-(void) startTimer :(NSString  *) anyImageFormat : (NSInteger) imagesUpperBound;
-(void) startRandomStatus :(NSArray  *) anyStatuses : (NSArray*) anyStatuImages : (UILabel*) anyLabel : (UIImageView*) anyImageView;
-(void) stopTimer;

-(void) configureImageAndBorderView;
+(NSString *) generateRandomPhone;
+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
@end
