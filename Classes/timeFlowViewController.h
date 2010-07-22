//
//  timeFlowViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeFlowViewController : UIViewController {
	
	NSTimer *clockTimer;
	NSMutableArray *runningTimers;
}

-(IBAction) toggleTouchUpInside:(id)sender;

@end

