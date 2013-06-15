//
//  editImage.h
//  HideMe
//
//  Created by Martijn Vandenberghe on 24/06/10.
//  Copyright 2010 Martijn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface editImage : UIViewController {
	UIImage *passedImage;
	
	IBOutlet UIImageView *piview;
	IBOutlet UISlider *slider;
	
	CGPoint lastPoint;
	BOOL mouseSwiped;	
	int mouseMoved;
		
	UIImage *imageToSave;
	NSString *mediaURLToPass;
}

- (IBAction) goTweetImg:(id)sender;

@property (nonatomic, retain) UIImage *passedImage;
@property (nonatomic, retain) NSString *mediaURLToPass;

@end
