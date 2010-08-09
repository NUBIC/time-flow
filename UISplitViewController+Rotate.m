//
//  UISplitViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 8/9/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "UISplitViewController+Rotate.h"


@implementation UISplitViewController ( Rotate )

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
