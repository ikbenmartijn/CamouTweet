//
//  HideMeViewController.m
//  HideMe
//
//  Created by Martijn Vandenberghe on 23/06/10.
//  Copyright Martijn 2010. All rights reserved.
//

#import "HideMeViewController.h"
#import "overDezeApp.h"
#import "editImage.h"

@implementation HideMeViewController

//@synthesize datePicker;
@synthesize selectedImage;

overDezeApp *svc;
editImage *vcedit;

- (IBAction) displayView:(id) sender
{
	/*UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Button Pressed" 
						  message:@"You have pressed the Button view."
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
    [alert show];
    [alert release];*/
	
	svc = [[overDezeApp alloc] 
							initWithNibName:@"overDezeApp" 
							bundle:nil];
	
	//svc.selectedDatePicker = datePicker;
	
	[UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
						   forView:self.view cache:YES];
	
	
    [self.view addSubview:svc.view];
	[UIView commitAnimations];
}

- (void) buttonsShouldEnable:(id)sender {
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	if (accessTokenString) {
		takePicture.enabled = YES;
		choosePicture.enabled = YES;
	}
}

- (void) showImagePicker:(id)sender {	
	NSLog(@"Afbeelding kiezen uit de bibliotheek");
	
	UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
	imagePickerVC.delegate = self;
	imagePickerVC.allowsEditing = NO;
	imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	[self presentModalViewController:imagePickerVC animated:YES];
	[imagePickerVC release];
}

- (void) showCamera:(id)sender {	
	NSLog(@"Foto nemen");
	
	UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
	imagePickerVC.delegate = self;
	imagePickerVC.allowsEditing = NO;
	imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera; //  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	[self presentModalViewController:imagePickerVC animated:YES];
	[imagePickerVC release];
}

- (void) imagePickerController:(UIImagePickerController *)imagePickerVC didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[imagePickerVC dismissModalViewControllerAnimated:YES];
	
	vcedit = [[editImage alloc] 
		   initWithNibName:@"editImage" 
		   bundle:nil];
	
	vcedit.passedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	[UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
						   forView:self.view cache:YES];
	
	
    [self.view addSubview:vcedit.view];
	[UIView commitAnimations];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];
	
	[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(buttonsShouldEnable:) userInfo:nil repeats:YES];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [userDefaults valueForKey:@"tuser"]; // @"username";
	NSString *password = [userDefaults valueForKey:@"tpass"]; // @"********";
	
	NSLog(@"u: %@, p: %@", username, password);
	
	if (username == NULL || password == NULL) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"CamouTweet" message:@"Make sure you fill in your Twitter username and password before using this app!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];		
		
		choosePicture.enabled = NO;
		takePicture.enabled = NO;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [overDezeApp release];
	[editImage release];
	
	[super dealloc];
}

@end
