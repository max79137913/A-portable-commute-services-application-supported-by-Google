//
//  SecondViewController.h
//  Driver
//
//  Created by  on 2012/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "singletonObj.h"
#import "QBKOverlayMenuView.h"


@interface SecondViewController : UIViewController<QBKOverlayMenuViewDelegate>
{
    CustomAlertView *customAlertView;
    CustomAlertView *startWorkAlertView;
    singletonObj * anotherSingle;
    QBKOverlayMenuView *_qbkOverlayMenu;
}
@property (strong, nonatomic) IBOutlet UIButton *tabbarControlBtn;
@property (strong, nonatomic) IBOutlet UIButton *passengerUpBtn;
@property (strong, nonatomic) IBOutlet UISwitch *sSwitch;

- (IBAction)showHideBar:(id)sender;
- (void) hideTabBar:(UITabBarController *) tabbarcontroller ;
- (void) showTabBar:(UITabBarController *) tabbarcontroller ;
- (IBAction)setPassengerUp:(id)sender;
- (IBAction)goSetting:(id)sender;
@end
