//
//  editImage.m
//  HideMe
//
//  Created by Martijn Vandenberghe on 24/06/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import "editImage.h"
#import "tweetImage.h"

@implementation editImage

@synthesize passedImage;
@synthesize mediaURLToPass;

tweetImage *vcTweet;
UIActivityIndicatorView *activityView;

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
	
	if (passedImage.size.width > passedImage.size.height) {
		piview.transform = CGAffineTransformMakeRotation(M_PI/2);
		
		[piview setBounds:CGRectMake(0, 0, 470, 320)];
		piview.image = passedImage;
	}
	else {
		piview.image = passedImage;
	}
	
	//piview.image = passedImage;
	mouseMoved = 0;
	piview.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self.view];	
	
	// create a new bitmap image context
	//
	UIGraphicsBeginImageContext(CGSizeMake(piview.image.size.width, piview.image.size.height));		//
	
	// get context
	//
	CGContextRef context = UIGraphicsGetCurrentContext();		
	
	// push context to make it current 
	// (need to do this manually because we are not drawing in a UIView)
	//
	UIGraphicsPushContext(context);								
	
	// drawing code comes here- look at CGContext reference
	// for available operations
	//
	// this example draws the inputImage into the context
	//
	[piview.image drawInRect:CGRectMake(0, 0, passedImage.size.width, passedImage.size.height)];
	
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), slider.value);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
	
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	// pop context 
	//
	UIGraphicsPopContext();								
	
	// get a UIImage from the image context- enjoy!!!
	//
	piview.image = UIGraphicsGetImageFromCurrentImageContext();
	
	// clean up drawing environment
	//
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	
	/*mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];	
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[piview.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), slider.value);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
	
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	//update de afbeelding
	piview.image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (IBAction) goTweetImg:(id)sender{
	imageToSave = piview.image;

	activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	activityView.center = CGPointMake(160,240);
	[self.view addSubview: activityView];
	[self.view bringSubviewToFront:activityView];
	
	[activityView startAnimating];
	
	UIImageWriteToSavedPhotosAlbum(imageToSave, self, @selector(image:didFinishSavingWithError:contextInfo:), self);
}
	
-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	/* Nu image uploaden naar twitpic */
	
	// create the URL
	NSURL *postURL = [NSURL URLWithString:@"http://twitpic.com/api/upload"];
	
	// create the connection
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
															   cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:30.0];
	
	// change type to POST (default is GET)
	[postRequest setHTTPMethod:@"POST"];
	
	
	// just some random text that will never occur in the body
	NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	
	// header value
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
								stringBoundary];
	
	// set header
	[postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	// create data
	NSMutableData *postBody = [NSMutableData data];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [userDefaults valueForKey:@"tuser"]; // @"username";
	NSString *password = [userDefaults valueForKey:@"tpass"]; // @"*************";
	
	NSLog(@"%@",username);
	NSLog(@"%@",[userDefaults valueForKey:@"tpass"]);
	
	NSString *message = @"This image was censored using @CamouTweetApp";
	
	// username part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// password part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// message part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	// media part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// get the image data from main bundle directly into NSData object
	//NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cats" ofType:@"jpg"];
	//NSData *imageData = [NSData dataWithContentsOfFile:piview.image];
	
	NSData *imageData = UIImagePNGRepresentation(piview.image);
	
	// add it to body
	[postBody appendData:imageData];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// final boundary
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

	// add body to post
	[postRequest setHTTPBody:postBody];
	
	// pointers to some necessary objects
	NSURLResponse* response;
	NSError * eror;
	
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	if (eror)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	// convert data into string
	NSString *responseString = [[[NSString alloc] initWithBytes:[responseData bytes]
														 length:[responseData length]
													   encoding:NSUTF8StringEncoding] autorelease];
	
	// see if we get a welcome result
	NSLog(@"%@", responseString);
	
	
	// create a scanner
	NSString *mediaURL = nil;
	NSScanner *scanner = [NSScanner scannerWithString:responseString];
	[scanner scanUpToString:@"<mediaurl>" intoString:nil];
	[scanner scanString:@"<mediaurl>" intoString:nil];
	[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"] intoString:&mediaURL];
	
	NSLog(@"mediaURL is %@", mediaURL);
	
	/* einde uploaden */
	
	vcTweet = [[tweetImage alloc] 
			   initWithNibName:@"tweetImage" 
			   bundle:nil];
	
	vcTweet.passedMediaURL = mediaURL;
	
	/*[UIView beginAnimations:@"flipping view" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
						   forView:self.view cache:YES];*/
	[activityView stopAnimating];
	[self presentModalViewController:vcTweet animated:YES];
	//[self.view addSubview:vcTweet.view];
	
	//[UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		NSLog(@"Ok, ga door met tweeten");
		
		vcTweet = [[tweetImage alloc] 
				  initWithNibName:@"tweetImage" 
				  bundle:nil];
		
		[UIView beginAnimations:@"flipping view" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
							   forView:self.view cache:YES];
		
		
		[self.view addSubview:vcTweet.view];
		[UIView commitAnimations];
	}
	else
	{
		NSLog(@"cancel");
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
