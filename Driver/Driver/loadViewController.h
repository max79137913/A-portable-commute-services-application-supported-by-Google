//
//  loadViewController.h
//  Driver
//
//  Created by  on 2012/7/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicateWithInternet.h"
#import "CustomAlertView.h"
//#import "Reachability.h"



@interface loadViewController : UIViewController
{
    NSString		*personName;
    NSString        *driverNum;
    NSString        *phoneNum;
    NSString        *carNum;
    NSData *imageData;
    
    NSString *driverid;
    NSOperationQueue *queue;
    CustomAlertView *waitAlert;
    UIActivityIndicatorView *indicator;
    CustomAlertView *noNetworkAlert;

}
@end
