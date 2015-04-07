//
//  settingViewController.m
//  Driver
//
//  Created by  on 2012/8/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "settingViewController.h"

@implementation settingViewController
@synthesize editButton;
@synthesize clearButton;

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
    sobj = [singletonObj singleObj];
    customAlertView = [[CustomAlertView alloc]initWithTitle:@"清除資料？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(sobj.setstarton){
        NSLog(@"yes");
    }else{
        NSLog(@"no");
        [editButton setEnabled:NO];
        [clearButton setEnabled:NO];
        [editButton setTitle:@"修改資料(已鎖定)" forState:UIControlStateDisabled];
        [clearButton setTitle:@"清除資料(已鎖定)" forState:UIControlStateDisabled];
    }
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [self setClearButton:nil];
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)backToLoginView:(id)sender {
    [self performSegueWithIdentifier:@"backToLogin" sender:self];
}

- (IBAction)clearLogin:(id)sender {
    [customAlertView show];
        
}
- (void) completeClearLogin
{
    // get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"loginData.plist"];
    // set the variables to the values in the text fields
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"Name",@"",@"Dnumber",@"",@"Pnumber",@"",@"Cnumber",Nil,@"imagedata", nil];
    
    NSString *error = nil;
	// create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    // check is plistData exists
	if(plistData) 
	{
		// write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else 
	{
        NSLog(@"Error in saveData: %@", error);
    }
    

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *page2=segue.destinationViewController;

   // NSString *vhgv=@"knkn" ;
     [page2 setValue:@"knkn" forKey:@"reviseMode"];

}
-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
           switch(buttonIndex){
            case 0:
                NSLog(@"Cancel…");
                break;
            case 1:
                NSLog(@"yes.....");
                   [self completeClearLogin];
                [self performSegueWithIdentifier:@"backToLogin" sender:self];
                break;
            default:
                break;
           }
}
@end
