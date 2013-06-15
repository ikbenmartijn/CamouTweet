//
//  appSettings.m
//  HideMe
//
//  Created by Martijn Vandenberghe on 20/07/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import "appSettings.h"
#import "HideMeViewController.h"

@implementation appSettings

@synthesize twitterEngine;

UIActivityIndicatorView *activityView;

- (IBAction)saveSettings:(id)sender{
	
	activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	activityView.center = CGPointMake(160,200);
	[self.view addSubview: activityView];
	[self.view bringSubviewToFront:activityView];
	
	[activityView startAnimating];
	
	NSString *tuser = twitterusername.text;
	NSString *tpass = twitterpassword.text;
	
	NSLog(@"%@",tuser);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:tuser forKey:@"tuser"];
	[userDefaults setValue:tpass forKey:@"tpass"];
	
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
	
	[self.twitterEngine exchangeAccessTokenForUsername:tuser password:tpass];
}

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	//
	// Note: do not use NSUserDefaults to store this in a production environment. 
	// ===== Use the keychain instead. Check out SFHFKeychainUtils if you want 
	//       an easy to use library. (http://github.com/ldandersen/scifihifi-iphone) 
	//
	NSLog(@"Access token string returned: %@", tokenString);
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
	
	[activityView stopAnimating];
	
	[self.view removeFromSuperview];
	// Enable the send tweet button.
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
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults valueForKey:@"tuser"]; // @"username";
	NSString *password = [userDefaults valueForKey:@"tpass"]; // @"*************";
	
	twitterusername.text = username;
	twitterpassword.text = password;
	
	[twitterusername addTarget:self action: @selector(naarpaswoord:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[twitterpassword addTarget:self action: @selector(saveSettings:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[twitterusername becomeFirstResponder];
}

- (void)naarpaswoord:(id)sender{
	[twitterusername resignFirstResponder];
	[twitterpassword becomeFirstResponder];
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


@end
