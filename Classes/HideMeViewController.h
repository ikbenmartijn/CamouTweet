//
//  HideMeViewController.h
//  HideMe
//
//  Created by Martijn Vandenberghe on 23/06/10.
//  Copyright Martijn 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@interface HideMeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	//IBOutlet UIDatePicker *datePicker;
	UIImage *selectedImage;
	
	IBOutlet UIButton *takePicture;
	IBOutlet UIButton *choosePicture;
}

- (IBAction) displayView:(id) sender;

- (void) buttonsShouldEnable:(id)sender;

- (void) showImagePicker:(id)sender;
- (void) showCamera:(id)sender;

//@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIImage *selectedImage;

@end

