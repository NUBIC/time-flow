    //
//  LogDetailViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 8/5/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "LogDetailViewController.h"


@implementation LogDetailViewController

@synthesize timerEvent, groupTitle, timerTitle, startedOn, endedOn;

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
	if(self.timerEvent){
		self.groupTitle.text = [NSString stringWithFormat:@"Group: %@", timerEvent.groupTitle];
		self.timerTitle.text = [NSString stringWithFormat:@"Timer: %@", timerEvent.timerTitle];
		self.startedOn.text = [NSString stringWithFormat:@"Started: %@ %@", [timerEvent startedTime], [timerEvent startedDate]];
		self.endedOn.text = [NSString stringWithFormat:@"Ended: %@ %@", [timerEvent endedTime], [timerEvent endedDate]];
	}
	
	self.navigationItem.title = @"Event";
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


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
