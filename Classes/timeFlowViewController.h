//
//  timeFlowViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeFlowViewController : UIViewController {

	UILabel *logbox;
	NSTimer *clockTimer;
	NSMutableArray *runningTimers;
	NSDate *startDate;

}

-(IBAction) toggleTouchUpInside:(id)sender;
//-(IBAction) toggleTouchDown:(id)sender;
//-(IBAction) toggleTouchUpOutside:(id)sender;
//-(IBAction) toggleTouchDragInside:(id)sender;
//-(IBAction) toggleTouchDragOutside:(id)sender;

@property (assign) IBOutlet UILabel *logbox;


@end

