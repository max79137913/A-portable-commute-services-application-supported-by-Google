//
//  FirstViewController.h
//  Driver
//
//  Created by  on 2012/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAlertView.h"
#import "singletonObj.h"
#import "QBKOverlayMenuView.h"




@interface FirstViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,QBKOverlayMenuViewDelegate>
{
    MKMapView *map;
    CLLocationManager *locManager;
    CustomAlertView *customAlertView;
    CustomAlertView *startWorkAlertView;

    singletonObj * sobj;
    
    QBKOverlayMenuView *_qbkOverlayMenu;
}
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIButton *tabbarControlBtn;
@property (strong, nonatomic) IBOutlet UIButton *passengerUpBtn;
@property (strong, nonatomic) IBOutlet UISwitch *fSwitch;

- (IBAction)showHideBar:(id)sender;
- (void) hideTabBar:(UITabBarController *) tabbarcontroller ;
- (void) showTabBar:(UITabBarController *) tabbarcontroller ;
- (IBAction)setPassengerUp:(id)sender;
- (IBAction)goSetting:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
