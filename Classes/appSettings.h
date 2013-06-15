//
//  appSettings.h
//  HideMe
//
//  Created by Martijn Vandenberghe on 20/07/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAuthTwitterEngine.h"

#define kOAuthConsumerKey		@"t0AKkNQLKOn4d6q6w2tVQ"
#define	kOAuthConsumerSecret	@"NxnxFOZWbrpC7mxbydQPokyrxJJOPhTcS0qfGQUTUNM"
#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@interface appSettings : UIViewController {
	IBOutlet UITextField *twitterusername;
	IBOutlet UITextField *twitterpassword;
	
	XAuthTwitterEngine *twitterEngine;
	
}

- (IBAction)saveSettings:(id)sender;
- (void)naarpaswoord:(id)sender;


@property (nonatomic, retain) XAuthTwitterEngine *twitterEngine;

@end
