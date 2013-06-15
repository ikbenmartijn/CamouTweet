//
//  tweetImage.m
//  HideMe
//
//  Created by Martijn Vandenberghe on 28/06/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import "tweetImage.h"
#import "HideMeViewController.h";
#import "editImage.h"

#import "XAuthTwitterEngine.h"

@implementation tweetImage
@synthesize tweetText, twitterEngine, passedMediaURL;

HideMeViewController *vcHoofdScherm;
editImage *vcEditImage;
UIActivityIndicatorView *activityView;

- (void)textViewDidChange:(UITextView *)textview{
	//NSLog(@"%d", [tweetText.text length]);
	//NSString *charsleft = NSString(@"%d chars left", [tweetText.text length]);
	charsLabel.text = [NSString stringWithFormat:@"%d chars left", 140 - [tweetText.text length]];
	
	if ([tweetText.text length] > 140) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Button Pressed" 
							  message:@"You have pressed the Button view."
							  delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(IBAction)backgroundTouched:(id)sender
{
	[tweetText resignFirstResponder];
}

- (IBAction)tweetUpdate:(id)sender{
	
	activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	activityView.center = CGPointMake(160,120);
	[self.view addSubview: activityView];
	[self.view bringSubviewToFront:activityView];
	
	[activityView startAnimating];
	
	NSString *update = tweetText.text;
	NSLog(@"About to send test tweet: \"%@\"", update);
	[self.twitterEngine sendUpdate:update];
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

	
    [super viewDidLoad];
	
	//[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kCachedXAuthAccessTokenStringKey];
	tweetText.text = [NSString stringWithFormat:@"%@", passedMediaURL];
	tweetText.delegate = self;
	[tweetText becomeFirstResponder];
	[self textViewDidChange:tweetText];
	
	// Sanity check
	if ([kOAuthConsumerKey isEqualToString:@""] || [kOAuthConsumerSecret isEqualToString:@""])
	{
		NSString *message = @"Please add your Consumer Key and Consumer Secret from http://twitter.com/oauth_clients/details/<your app id> to the XAuthTwitterEngineDemoViewController.h before running the app. Thank you!";
		NSLog(@"Missing oAuth details", message, @"OK");
	}
	else {
		NSLog(@"Credentials found, everything ok");
	}

	
	//
	// Initialize the XAuthTwitterEngine.
	//
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
	
	NSLog(@"%@", twitterEngine);
	if ([self.twitterEngine isAuthorized])
	{
		NSLog(@"Cached xAuth token found!", @"This app was previously authorized for a Twitter account so you can press the second button to send a tweet now.", @"OK");
	}
	else {
		NSLog(@"No Cached xAuth token found!");
		
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		NSString *username = [userDefaults valueForKey:@"tuser"]; // @"username";
		NSString *password = [userDefaults valueForKey:@"tpass"]; // @"********";
		
		NSLog(@"%@",[userDefaults valueForKey:@"tuser"]);
		
		NSLog(@"About to request an xAuth token exchange for username: ]%@[ password: ]%@[.",
			  username, password);
		
		[self.twitterEngine exchangeAccessTokenForUsername:username password:password];
	}

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
    [super dealloc];
}

#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	//
	// Note: do not use NSUserDefaults to store this in a production environment. 
	// ===== Use the keychain instead. Check out SFHFKeychainUtils if you want 
	//       an easy to use library. (http://github.com/ldandersen/scifihifi-iphone) 
	//
	NSLog(@"Access token string returned: %@", tokenString);
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
	
	// Enable the send tweet button.
	
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
	NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
	
	NSLog(@"Tweet sent!", @"The tweet was successfully sent. Everything works!", @"OK");
	
	[UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
						   forView:self.view.superview cache:YES];
	
	[activityView stopAnimating];
	
	[self.view removeFromSuperview];
	[UIView commitAnimations];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
	NSString *errorstring = [NSString stringWithFormat:@"Twitter request failed: %@ with error:%@", connectionIdentifier, error];
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request error" message:errorstring delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
    [alert show];
	
	if ([[error domain] isEqualToString: @"HTTP"])
	{
		switch ([error code]) {
				
			case 401:
			{
				// Unauthorized. The user's credentials failed to verify.
				NSLog(@"Oops!", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
				break;				
			}
				
			case 502:
			{
				// Bad gateway: twitter is down or being upgraded.
				NSLog(@"Fail whale!", @"Looks like Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
				break;				
			}
				
			case 503:
			{
				// Service unavailable
				NSLog(@"Hold your taps!", @"Looks like Twitter is overloaded. Please wait a few seconds and try again.", @"OK");	
				break;								
			}
				
			default:
			{
				NSString *errorMessage = [[NSString alloc] initWithFormat: @"%d %@", [error	code], [error localizedDescription]];
				NSLog(@"Twitter error!", errorMessage, @"OK");	
				[errorMessage release];
				break;				
			}
		}
		
	}
	else 
	{
		switch ([error code]) {
				
			case -1009:
			{
				NSLog(@"You're offline!", @"Sorry, it looks like you lost your Internet connection. Please reconnect and try again.", @"OK");					
				break;				
			}
				
			case -1200:
			{
				NSLog(@"Secure connection failed", @"I couldn't connect to Twitter. This is most likely a temporary issue, please try again.", @"OK");					
				break;								
			}
				
			default:
			{				
				NSString *errorMessage = [[NSString alloc] initWithFormat:@"%@ xx %d: %@", [error domain], [error code], [error localizedDescription]];
				NSLog(@"Network Error!", errorMessage , @"OK");
				[errorMessage release];
			}
		}
	}
	
}


@end
