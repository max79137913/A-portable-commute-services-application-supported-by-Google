//
//  loadViewController.m
//  Driver
//
//  Created by  on 2012/7/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "loadViewController.h"

@implementation loadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    noNetworkAlert=[[CustomAlertView alloc] initWithTitle:@"無網路連線" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];

    
    //set thread
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:2];
    
    waitAlert=[[CustomAlertView alloc] initWithTitle:@"請稍後" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    
    [waitAlert addSubview:indicator];
}
-(void)waitAlertBegin
{
    [waitAlert show];
    [indicator startAnimating];
}
-(void)waitAlertEnd
{
    [indicator stopAnimating];
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
  
  }
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];   
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];    
    if (networkStatus == NotReachable) {        
        NSLog(@"There IS NO internet connection");
        [noNetworkAlert show];
    }else{
     */
    
    
    // Data.plist code
	// get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"loginData.plist"];
	
	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:@"loginData" ofType:@"plist"];
	}
    
    // read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp) 
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
    
    
    //test plist have data
    personName=[temp objectForKey:@"Name"];
    driverNum=[temp objectForKey:@"Dnumber"];
    phoneNum=[temp objectForKey:@"Pnumber"];
    carNum=[temp objectForKey:@"Cnumber"];
    imageData=[temp objectForKey:@"imagedata"];
    
    driverid=[temp objectForKey:@"driverid"];
    
    NSLog(@"driverid:%d",driverid.intValue);

    //if (!driverNum){
      //  NSLog(@"yes%@",driverNum);}
    //if (personName){
       // NSLog(@"yes%@",personName);}
    
    if (!personName || !driverNum || !phoneNum || !carNum || [carNum isEqualToString:@""] ||[phoneNum isEqualToString:@""] ||[driverNum isEqualToString:@""] ||[personName isEqualToString:@""] || !imageData || driverid==0) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }else{
        NSLog(@"start");
        [NSThread detachNewThreadSelector: @selector(waitAlertBegin) toTarget:self withObject:nil];

        NSData *data = [CommunicateWithInternet getJsonDataFromUrl:@"http://mrtaxibkend.herokuapp.com/drivers/login" WithPostParams:[NSDictionary dictionaryWithObjectsAndKeys:driverid,@"driver_id", carNum,@"card",nil]];
        
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString *status = [json objectForKey:@"status"];
        
        NSLog(@"login status:%@",status);
        
        [NSThread detachNewThreadSelector: @selector(waitAlertEnd) toTarget:self withObject:nil];
        
       // NSLog(@"yes%@",driverNum);
        [self performSegueWithIdentifier:@"start" sender:self];
    }
        
   // }
        
}

@end
