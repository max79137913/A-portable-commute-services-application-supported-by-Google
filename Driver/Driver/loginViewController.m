//
//  loginViewController.m
//  Driver
//
//  Created by  on 2012/7/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"
#import "NSString+Base64.h"


@implementation loginViewController
@synthesize nameField;
@synthesize DriverNumber;
@synthesize PhoneNumber;
@synthesize CarNumber;
@synthesize photo;
@synthesize reviseMode;

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
    imagePicker=[[UIImagePickerController alloc] init];
    customAlertView = [[CustomAlertView alloc]initWithTitle:@"Choose your photo" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"From Photo",@"From Camera",nil];
    
    waitAlert=[[CustomAlertView alloc] initWithTitle:@"請稍後" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    
    [waitAlert addSubview:indicator];
    
    //set thread
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:2];
   
    
    

    [super viewDidLoad];
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
    
    // assign values
    personName=[temp objectForKey:@"Name"];
    driverNum=[temp objectForKey:@"Dnumber"];
    phoneNum=[temp objectForKey:@"Pnumber"];
    carNum=[temp objectForKey:@"Cnumber"];
    // display values
    nameField.text=personName;
    DriverNumber.text=driverNum;
    PhoneNumber.text=phoneNum;
    CarNumber.text=carNum;
    imageData=[temp objectForKey:@"imagedata"];
    UIImage *headphoto=[UIImage imageWithData:imageData];
    
    if (!headphoto) {
        [self.photo setImage:[UIImage imageNamed:@"headphoto.png"] forState:UIControlStateNormal];
    }else{
        [self.photo setImage:[UIImage imageWithData:imageData] forState:UIControlContentHorizontalAlignmentCenter];
    }
}


- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setDriverNumber:nil];
    [self setPhoneNumber:nil];
    [self setCarNumber:nil];
    [self setPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)changeImageFromView:(id)sender {
    [customAlertView show];
}

- (IBAction)saveDataAndQuit:(id)sender {
    
    NSString *imagePNGBase64String=[NSString base64StringFromData:imageData length:imageData.length];
    
    
    /****************************************/
    /* 需要設定device_type*/
    NSString *device_type=@"0";
    
    /***************************************/
    NSString *device_id=@"iOS";
    
    
    [NSThread detachNewThreadSelector: @selector(waitAlertBegin) toTarget:self withObject:nil];
    
    
    NSData *data = [CommunicateWithInternet getJsonDataFromUrl:@"http://mrtaxibkend.herokuapp.com/passengers/register" WithPostParams:[NSDictionary dictionaryWithObjectsAndKeys:nameField.text, @"name",DriverNumber.text, @"license", CarNumber.text, @"card",imagePNGBase64String , @"photo",device_type,@"device_type",device_id,@"device_id", nil]];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    
    
    
        
    
    // get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"loginData.plist"];
    // set the variables to the values in the text fields
    personName=nameField.text;
    NSLog(@"%@",personName);
    driverNum=DriverNumber.text;
    phoneNum=PhoneNumber.text;
    carNum=CarNumber.text;
    
    driverId=[json objectForKey:@"driver_id"];
    NSLog(@"driverId:%@",driverId);
    
    
    // create dictionary with values in UITextFields
  //  NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: personName, driverNum,phoneNum,carNum, nil] forKeys:[NSArray arrayWithObjects: @"Name", @"Dnumber",@"Pnumber",@"Cnumber", nil]];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjectsAndKeys:personName,@"Name",driverNum,@"Dnumber",phoneNum,@"Pnumber",carNum,@"Cnumber",imageData,@"imagedata",driverId,@"driverid", nil];

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
    NSData *data2 = [CommunicateWithInternet getJsonDataFromUrl:@"http://mrtaxibkend.herokuapp.com/drivers/login" WithPostParams:[NSDictionary dictionaryWithObjectsAndKeys:driverId,@"driver_id", carNum,@"card",nil]];
    
    [NSThread detachNewThreadSelector: @selector(waitAlertEnd) toTarget:self withObject:nil];

    id json2 = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    
    NSString *status2 = [json2 objectForKey:@"status"];
    
    NSLog(@"login status:%@",status2);

    
    
       
    
    if ([reviseMode isEqualToString:@"knkn"]) {
        NSLog(@"dcdsdc");
        //[self dismissViewControllerAnimated:YES completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];

    }else{

    
    
    [self performSegueWithIdentifier:@"loginComplete" sender:self];
 }
}

- (IBAction)textFieldReturn:(id)sender {
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.x = +0.0f;
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.x = +44.0f;
    self.view.frame = rect;
    [UIView commitAnimations];

}

- (IBAction)carNumEditBegin:(id)sender {
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.x = +88.0f;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
-(void) pickImage
{
    [imagePicker setDelegate:self];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    
        
    
    [self presentModalViewController:imagePicker animated:YES];
    
}

-(void) pickImageFromCamera
{
    [imagePicker setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"camera");
        //imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    }
    NSLog(@"no camera");
    
}

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
	switch(buttonIndex){
		case 0:
			NSLog(@"Cancel…");
			break;
		case 1:
			[self pickImage];
			break;
		default:
			[self pickImageFromCamera];
			break;
	}
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info objectForKey:UIImagePickerControllerOriginalImage]==NULL) {
        NSLog(@"vs");
    }
    if ([info objectForKey:UIImagePickerControllerEditedImage]==NULL) {
        NSLog(@"vs");
    }
    [self.photo setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //image=[[UIImage alloc] initWithData:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage])];
   imageData = UIImagePNGRepresentation(image);
    //自行指定儲存的檔名
    NSString *paths=NSHomeDirectory(); 
    NSLog(@"%@",paths);
    NSString *filename=@"temp.png";
    NSString *pathoffilesave=[paths stringByAppendingPathComponent:filename];   
    
    //儲存
    [imageData writeToFile:pathoffilesave atomically:NO];
   
    
    [picker dismissModalViewControllerAnimated:YES];
    
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


@end
