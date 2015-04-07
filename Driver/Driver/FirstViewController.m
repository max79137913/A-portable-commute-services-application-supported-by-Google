//
//  FirstViewController.m
//  Driver
//
//  Created by  on 2012/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "QBKOverlayMenuView.h"

#define kGuestUpAlertView 1
#define kStartWorkAlertView 2

@implementation FirstViewController
@synthesize map;
@synthesize tabbarControlBtn;
@synthesize passengerUpBtn;
@synthesize fSwitch;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    locManager=[[CLLocationManager alloc] init];
    locManager.delegate=self;
    locManager.desiredAccuracy=kCLLocationAccuracyBest;
    locManager.distanceFilter=100.0f;
    [locManager startUpdatingLocation];
    map.showsUserLocation=YES;
    customAlertView = [[CustomAlertView alloc]initWithTitle:@"乘客已經上車？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    customAlertView.tag=kGuestUpAlertView;
    startWorkAlertView = [[CustomAlertView alloc] initWithTitle:@"開始載客?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    startWorkAlertView.tag=kStartWorkAlertView;
    
    [super viewDidLoad];
    sobj = [singletonObj singleObj];
	// Do any additional setup after loading the view, typically from a nib.
    QBKOverlayMenuViewOffset offset;
    offset.bottomOffset = 44;
    
    _qbkOverlayMenu = [[QBKOverlayMenuView alloc] initWithDelegate:self position:kQBKOverlayMenuViewPositionDefault offset:offset];
    [_qbkOverlayMenu setParentView:[self view]];
    
    [_qbkOverlayMenu addButtonWithTitle:@"開始載客" index:0];
    [_qbkOverlayMenu addButtonWithTitle:@"資料設定" index:1];
    
    passengerUpBtn.hidden=YES;
     sobj.showHidepassengerUpBtn=YES;
    
    [_qbkOverlayMenu performButtonPressed];
    sobj.unfold=NO;
    sobj.setstarton=YES;

}

- (void)viewDidUnload
{
    [self setMap:nil];
    [self setTabbarControlBtn:nil];
    [self setPassengerUpBtn:nil];
    [self setFSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self hideTabBar:self.tabBarController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.fSwitch setOn:sobj.setting animated:NO];
    self.passengerUpBtn.hidden=sobj.showHidepassengerUpBtn;
    //[_qbkOverlayMenu performButtonPressed];
    [_qbkOverlayMenu setMenuUnFolded:sobj.unfold];
    
    UIButton *mbutton=[_qbkOverlayMenu.additionalButtons objectAtIndex:0];
    if (sobj.setstarton) {
        [mbutton setTitle:@"開始載客" forState:UIControlStateNormal];
    }else{
        [mbutton setTitle:@"載客中..." forState:UIControlStateNormal];

       
    }
    

    

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    double X = newLocation.coordinate.latitude;
    double Y = newLocation.coordinate.longitude;
    
    //設定經緯度
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = X;
    mapCenter.longitude = Y;
    
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.01;
    mapSpan.longitudeDelta = 0.01;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;

    //前往顯示位置
    [map setRegion:mapRegion];

}
- (IBAction)showHideBar:(id)sender {
    if([tabbarControlBtn.currentTitle isEqualToString:@"show"]){
        [self showTabBar:self.tabBarController];
        //[tabbarControlBtn setFrame:CGRectMake(tabbarControlBtn.frame.origin.x, 210, tabbarControlBtn.frame.size.width, tabbarControlBtn.frame.size.height )];
        [tabbarControlBtn setTitle:@"hide" forState:UIControlStateNormal];
    }else{
        [self hideTabBar:self.tabBarController]; 
        
        [tabbarControlBtn setTitle:@"show" forState:UIControlStateNormal];
        //[tabbarControlBtn setFrame:CGRectMake(tabbarControlBtn.frame.origin.x, 260, tabbarControlBtn.frame.size.width, tabbarControlBtn.frame.size.height )];
    }
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 320, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 320)];
        }
        
    }
    [tabbarControlBtn setFrame:CGRectMake(tabbarControlBtn.frame.origin.x, 260, tabbarControlBtn.frame.size.width, tabbarControlBtn.frame.size.height )];
    [passengerUpBtn setFrame:CGRectMake(passengerUpBtn.frame.origin.x, 260, passengerUpBtn.frame.size.width, passengerUpBtn.frame.size.height )];
    [UIView commitAnimations];
    
    
    
    
    
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 271, view.frame.size.width, view.frame.size.height)];
            
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 271)];
        }
        
        
    }
    [tabbarControlBtn setFrame:CGRectMake(tabbarControlBtn.frame.origin.x, 210, tabbarControlBtn.frame.size.width, tabbarControlBtn.frame.size.height )];
    [passengerUpBtn setFrame:CGRectMake(passengerUpBtn.frame.origin.x, 210, passengerUpBtn.frame.size.width, passengerUpBtn.frame.size.height )];
    [UIView commitAnimations]; 
}

- (IBAction)setPassengerUp:(id)sender {
    [customAlertView show];
}

- (IBAction)goSetting:(id)sender {
    [self performSegueWithIdentifier:@"setting" sender:self];
}

- (IBAction)switchChanged:(id)sender {
    if (fSwitch.isOn) {
        [startWorkAlertView show];
    }else{
        sobj.setting=fSwitch.isOn;
    }

}
-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (alertView.tag == kGuestUpAlertView) {
        switch(buttonIndex){
		case 0:
			NSLog(@"Cancel…");
			break;
		case 1:
			NSLog(@"yes.....");
			break;
		default:
			break;
        }
    }else if( alertView.tag == kStartWorkAlertView){
        /*
        switch(buttonIndex){
            case 0:
                NSLog(@"Cancel…");
                [fSwitch setOn:NO animated:YES];
                break;
            case 1:
                passengerUpBtn.hidden=NO;
                //UIButton *mbutton=[_qbkOverlayMenu.additionalButtons objectAtIndex:0];
                //[mbutton setTitle:@"載客中..." forState:UIControlStateNormal];
                [_qbkOverlayMenu performButtonPressed];
                [self hideTabBar:self.tabBarController];
                NSLog(@"yes.....");                
                [fSwitch setOn:YES animated:NO];
                break;
            default:
                break;
        }
         */
        if (buttonIndex == 0) {
            NSLog(@"Cancel…");
            [fSwitch setOn:NO animated:YES];
        }else if(buttonIndex == 1){
            passengerUpBtn.hidden=NO;
            sobj.showHidepassengerUpBtn=NO;
            UIButton *mbutton=[_qbkOverlayMenu.additionalButtons objectAtIndex:0];
            [mbutton setTitle:@"載客中..." forState:UIControlStateNormal];
            sobj.setstarton=NO;
            [_qbkOverlayMenu performButtonPressed];
            //sobj.unfold=YES;
            [self hideTabBar:self.tabBarController];
            NSLog(@"yes.....");                
            [fSwitch setOn:YES animated:NO];
        }
        
        sobj.setting=fSwitch.isOn;

    }
}

#pragma mark - Métodos de QBKOverlayMenuViewDelegate
- (void)overlayMenuView:(QBKOverlayMenuView *)overlayMenuView didActivateAdditionalButtonWithIndex:(NSInteger)index
{
    NSLog(@"Botón pulsado con índice: %d", index);
    if (index == 0 ) {
        
        UIButton *mbutton=[_qbkOverlayMenu.additionalButtons objectAtIndex:index];
        if ([mbutton.currentTitle isEqualToString:@"開始載客"]) {
            //[mbutton setTitle:@"載客中..." forState:UIControlStateNormal];
            [startWorkAlertView show];
           // if ([passengerUpBtn isHidden] == NO) {
             //   NSLog(@"dd");
               // [mbutton setTitle:@"載客中..." forState:UIControlStateNormal];
            //}
        }else if([mbutton.currentTitle isEqualToString:@"載客中..."])
        {
            [mbutton setTitle:@"開始載客" forState:UIControlStateNormal];
            passengerUpBtn.hidden=YES;
            sobj.showHidepassengerUpBtn=YES;
            sobj.setstarton=YES;
            
        }
        
    }else if(index == 1){
        [self performSegueWithIdentifier:@"setting" sender:self];
    }else{
        
    }
    
   
       
    
    //[mbutton buttonType
    //mbutton.backgroundColor=[UIColor blueColor];
}

- (void)didPerformUnfoldActionInOverlayMenuView:(QBKOverlayMenuView *)overlaymenuView
{
    NSLog(@"Menú DESPLEGADO");
    sobj.unfold=NO;
    [self showTabBar:self.tabBarController];
}

- (void)didPerformFoldActionInOverlayMenuView:(QBKOverlayMenuView *)overlaymenuView
{
    NSLog(@"Menú REPLEGADO");
    sobj.unfold=YES;
    [self hideTabBar:self.tabBarController];

}




@end
