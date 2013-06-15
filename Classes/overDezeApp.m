//
//  SecondViewController.m
//  HideMe
//
//  Created by Martijn Vandenberghe on 23/06/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import "overDezeApp.h"
#import "appSettings.h"

@implementation overDezeApp

//@synthesize selectedDatePicker;

appSettings *vcsettings;

-(IBAction) btnReturn:(id) sender
{
	[UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
						   forView:self.view.superview cache:YES];

	
	[self.view removeFromSuperview];
	
	[UIView commitAnimations];
}


- (IBAction) showApplicationSettings:(id) sender
{	
	vcsettings = [[appSettings alloc] 
		   initWithNibName:@"appSettings" 
		   bundle:nil];	
	
	[self presentModalViewController:vcsettings animated:YES];
	//[self.view addSubview:vcsettings.view];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	/*NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    
	
	//NSLog(@"%@", selectedDatePicker);
    UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Date and time selected" 
						  message:[formatter stringFromDate:selectedDatePicker.date] 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
    [alert show];
    [alert release];*/
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[selectedDatePicker release];
    [super dealloc];
}


@end
