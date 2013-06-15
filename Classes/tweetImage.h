//
//  tweetImage.h
//  HideMe
//
//  Created by Martijn Vandenberghe on 28/06/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAToken.h";
#import "XAuthTwitterEngine.h"

#define kOAuthConsumerKey		@"t0AKkNQLKOn4d6q6w2tVQ"
#define	kOAuthConsumerSecret	@"NxnxFOZWbrpC7mxbydQPokyrxJJOPhTcS0qfGQUTUNM"
#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@interface tweetImage : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *tweetText;
	IBOutlet UILabel *charsLabel;
	
	XAuthTwitterEngine *twitterEngine;
	
	NSString *passedMediaURL;
}

@property (nonatomic, retain) IBOutlet UITextView *tweetText;
@property (nonatomic, retain) XAuthTwitterEngine *twitterEngine;
@property (nonatomic, retain) NSString *passedMediaURL;

- (void)textViewDidChange:(UITextView *)tweetText;

- (IBAction)backgroundTouched:(id)sender;
- (IBAction)tweetUpdate:(id)sender;

@end
