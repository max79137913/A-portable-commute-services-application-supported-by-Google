//
//  loginViewController.h
//  Driver
//
//  Created by  on 2012/7/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "CommunicateWithInternet.h"


@interface loginViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString		*personName;
    NSString        *driverNum;
    NSString        *phoneNum;
    NSString        *carNum;
    NSString *driverId;

    
    UIImagePickerController *imagePicker;
    CustomAlertView *customAlertView;
    CustomAlertView *waitAlert;

    UIImageView *imageView;
    
    NSData *imageData;
    NSOperationQueue *queue;
    UIActivityIndicatorView *indicator;

    
}
@property (weak)     NSString *reviseMode;
 

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *DriverNumber;
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *CarNumber;
@property (strong, nonatomic) IBOutlet UIButton *photo;
- (IBAction)changeImageFromView:(id)sender;
- (IBAction)saveDataAndQuit:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)carNumEditBegin:(id)sender;

@end
