//
//  HideMeAppDelegate.h
//  HideMe
//
//  Created by Martijn Vandenberghe on 23/06/10.
//  Copyright Martijn 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HideMeViewController;

@interface HideMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HideMeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HideMeViewController *viewController;

@end

