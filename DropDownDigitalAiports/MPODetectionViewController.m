// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license.
//
// Microsoft Cognitive Services (formerly Project Oxford): https://www.microsoft.com/cognitive-services
//
// Microsoft Cognitive Services (formerly Project Oxford) GitHub:
// https://github.com/Microsoft/ProjectOxford-ClientSDK
//
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#import "MPOImageCollectionViewCell.h"
#import "MPODetectionViewController.h"
#import "MPODetectionCollectionViewCell.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>
#import "MPOUtilities.h"
#import "Constants.h"
#import "MPOActivityIndicatorViewController.h"
#import "AppDelegate.h"
@interface MPODetectionFaceCellObject : NSObject
@property (nonatomic, strong) UIImage *croppedFaceImage;
@property (nonatomic, strong) NSString *ageText;
@property (nonatomic, strong) NSString *genderText;
@property (nonatomic, strong) NSString *headPoseText;
@property (nonatomic, strong) NSString *glassesText;
@property (nonatomic, strong) NSString *moustacheText;
@property (nonatomic, strong) NSString *smileText;
@end

@implementation MPODetectionFaceCellObject
@end

@interface MPODetectionViewController (){
    bool hasImage;
    NSInteger selectedIndex;
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) NSMutableArray *faceCellObjects;

@end


@implementation MPODetectionViewController

@synthesize detailItem = _detailItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.imageView.layer setMasksToBounds:YES];
    [self.imageView.layer setCornerRadius:3.0f];
    
    selectedIndex = -1;
    hasImage = false;
    self.faceCellObjects = [[NSMutableArray alloc] init];
    
    appDelegate = [AppDelegate currentDelegate] ;
 
    if (appDelegate.isMissingPerson){
        [self.imageView setImage:appDelegate.missingPersonImage];
        [self.btnBroadCast setBackgroundColor:[UIColor darkGrayColor]];
        [self.numberOfFacesDetectedLabel setText:@"Click The 'Report' Button Below To Contact Airport Security"];
        [self.btnBroadCast setTitle:@"Report Information" forState:UIControlStateNormal];
        [self.btnBroadCast setHidden:NO];
    }else{
        
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectImageButtonPressed:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select a photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:picker animated:YES completion:nil];

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Use Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:picker animated:YES completion:nil];

    }]];
    

    
    if (appDelegate.isiPhone){
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    }else{
        
        UIPopoverPresentationController *alertPopoverPresentationController = actionSheet.popoverPresentationController;
 
 
        alertPopoverPresentationController.sourceRect = self.imageView.frame ;
        alertPopoverPresentationController.sourceView = self.imageView;
        
        [self showDetailViewController:actionSheet sender:sender];
    }

}
- (void)runDetection {
    
    //remove any existing faces, if we have run detection previously
    
    [self.faceCellObjects removeAllObjects];
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithSubscriptionKey:ProjectOxfordFaceSubscriptionKey];
    
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.8);

    //show loading indicator
    MPOActivityIndicatorViewController *indicatorViewController = [[MPOActivityIndicatorViewController alloc] init];
    [self presentViewController:indicatorViewController animated:YES completion:nil];
    
    [client detectWithData:data
              returnFaceId:YES
       returnFaceLandmarks:YES
      returnFaceAttributes:@[@(MPOFaceAttributeTypeAge), @(MPOFaceAttributeTypeFacialHair), @(MPOFaceAttributeTypeGlasses), @(MPOFaceAttributeTypeSmile), @(MPOFaceAttributeTypeGender),@(MPOFaceAttributeTypeHeadPose)]
           completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else {

            switch (collection.count) {
                case 0:
                    self.numberOfFacesDetectedLabel.text = @"Unable to Detect any Faces";
                    
                    hasImage = false;
                    [self.btnReset setHidden:NO];
                    break;
                case 1:
                    self.numberOfFacesDetectedLabel.text = [NSString stringWithFormat:@"%@ Face Detected,\nPlease Select the Missing Person Below", @(collection.count)];
                    break;
                    
                default:
                     self.numberOfFacesDetectedLabel.text = [NSString stringWithFormat:@"%@ Faces Detected,\nPlease Scrow and Select the Missing Person Below", @(collection.count)];
                    
                    break;
            }
            
 
            for (MPOFace *face in collection) {
  
                UIImage *croppedImage = [MPOUtilities cropImageToFaceRectangle:self.imageView.image faceRectangle:face.faceRectangle];
                
                MPODetectionFaceCellObject *obj = [[MPODetectionFaceCellObject alloc] init];
                
                obj.croppedFaceImage = croppedImage;
                
                obj.ageText = [NSString stringWithFormat:@" Age: %@", face.attributes.age.stringValue];
                obj.genderText = [NSString stringWithFormat:@" Gender: %@", face.attributes.gender.capitalizedString];
                obj.headPoseText = [NSString stringWithFormat:@" Head Pose: Roll(%@º), Yaw(%@º)", face.attributes.headPose.roll.stringValue, face.attributes.headPose.yaw.stringValue];
                
                obj.glassesText =  [NSString stringWithFormat:@" Glasses: %@", face.attributes.glasses];
                obj.moustacheText = [NSString stringWithFormat:@" Moustache: %@, Beard %@", face.attributes.facialHair.mustache.stringValue, face.attributes.facialHair.beard.stringValue];
                obj.smileText = [NSString stringWithFormat:@" Smile: %@", face.attributes.smile];

                [self.faceCellObjects addObject:obj];
                
            }
            [self.collectionView reloadData];
       
        }
        
        //hide loading indicator
        [self dismissViewControllerAnimated:YES completion:^(void){

        }];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    if (! appDelegate.isiPhone){
        chosenImage = info[UIImagePickerControllerOriginalImage];
    }
        self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:^(void){
        hasImage = true;
        [self.btnReset setHidden:YES];
        [self.btnDetect setHidden:NO];
    }];
}

- (IBAction)detectionButtonPressed:(id)sender {
    
    UIAlertController *alert = nil;
    UIAlertAction *okAction = nil;
    
    @try {
        
        if (self.imageView.image && hasImage) {
            [self runDetection];
        }else{
            alert = [UIAlertController alertControllerWithTitle:@"Face Image Selection"
                                                        message:@"Please select an image using the action button above"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:nil];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^(void){
 
            }];
        }

        
    } @catch (NSException *exception) {
        
    } @finally {
        alert = nil;
        okAction = nil;
    }
  }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count  = 0;
    
    if (self.faceCellObjects){
        count =[self.faceCellObjects count];
    }
    
    if (count > 0){
        [self.btnReset setHidden:NO];
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPODetectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MPODetectionFaceCellObject *obj = [self.faceCellObjects objectAtIndex:indexPath.row];

    CGColorRef *borderColor = (CGColorRef*) [self.view.tintColor CGColor];
    
    cell.genderLabel.text = obj.genderText;
    
    cell.ageLabel.text = obj.ageText;
    
    cell.glassesLabel.text = obj.glassesText;
    
    
    if ([obj.genderText containsString:@"Male"]){
        cell.moustacheLabel.text = obj.moustacheText;
    }else{
        cell.moustacheLabel.text = obj.headPoseText;
    }
    
    obj.smileText = [obj.smileText stringByReplacingOccurrencesOfString:@"(null)" withString:@"n/a"];
    
    cell.smileLabel.text = obj.smileText;
    
    cell.imageView.image = obj.croppedFaceImage;
   /* [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:5.0f];*/
    if (indexPath.row == selectedIndex){
        borderColor = (CGColorRef*) [[UIColor redColor] CGColor];
    }
    [cell.imageView.layer setBorderColor:borderColor];
    [cell.imageView.layer setBorderWidth:3.0f];


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    [self.btnBroadCast setHidden:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, 210);
}
- (IBAction)resetDetectionAction:(UIButton *)sender {
  
    if(self.faceCellObjects){
        if (self.faceCellObjects.count > 0){
            [self.faceCellObjects removeAllObjects];
            [self.collectionView reloadData];
        }
    }
  

    [self.imageView setImage:[UIImage imageNamed:@"facial_recognition_scan_filled.png"]];
    [self.numberOfFacesDetectedLabel setText:@""];
    hasImage  = false;
    [self.btnReset setHidden:YES];
    [self.btnDetect setHidden:YES];
    [self.btnBroadCast setHidden:YES];
}



- (IBAction)broadCastAction:(UIButton *)sender {
    
    UIAlertController *alert = nil;
    
    UIAlertAction *okAction = nil,
                            *cancelAction = nil;
    
    
    @try {
        
        
        if ([self.btnBroadCast.titleLabel.text isEqualToString:@"Report Information"]){
            
 
            alert = [UIAlertController alertControllerWithTitle:@"Missing Person Information"
                                                        message:@"Would You Like to Report Information About This Missing Person?"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            
            okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *anyAction){
                [appDelegate setMissingPersonImage:nil];
                [appDelegate setIsMissingPerson:NO];
                [self.navigationItem setTitle:@"Security Will Be Here Shortly."];
                [self setTitle:@"Security Will Be Here Shortly."];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
            
            cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *anyAction){

                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
 
        }else{
        
        alert = [UIAlertController alertControllerWithTitle:@"Broadcast Confirmation"
                                                    message:@"Would You Like to Broadcast this Person Missing?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        

        okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *anyAction){

            
        
            MPODetectionFaceCellObject *obj  = [self.faceCellObjects objectAtIndex:selectedIndex];
            
            if (obj){
                [appDelegate setMissingPersonImage:obj.croppedFaceImage];
                [appDelegate setIsMissingPerson:YES];
                [self.btnBroadCast setHidden:YES];
                [self.btnReset setHidden:YES];
                [self.btnDetect setHidden:YES];
                [self.navigationItem.rightBarButtonItem setEnabled:NO];
                [self resetDetectionAction:self.btnReset];
                [self performSegueWithIdentifier:@"segUnload" sender:self];
                [self dismissViewControllerAnimated:YES completion:^(void){
                
                }];

            }
            
        }];
        
        cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *anyAction){
                [appDelegate setMissingPersonImage:nil];
                [appDelegate setIsMissingPerson:NO];
               [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        }
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
}
@end
