//
//  timeFlowAppDelegate.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class timeFlowViewController;

@interface timeFlowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    timeFlowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet timeFlowViewController *viewController;

@end

