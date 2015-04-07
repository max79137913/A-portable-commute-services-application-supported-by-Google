//
//  settingViewController.h
//  Driver
//
//  Created by  on 2012/8/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "singletonObj.h"
#import "CustomAlertView.h"


@interface settingViewController : UIViewController
{
    singletonObj * sobj;
    CustomAlertView *customAlertView;
}
- (IBAction)back:(id)sender;
- (IBAction)backToLoginView:(id)sender;
- (IBAction)clearLogin:(id)sender;
- (void) completeClearLogin;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

@end
