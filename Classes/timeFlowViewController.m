//
//  timeFlowViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import "timeFlowViewController.h"
#import "NUBICSelectableTimerButton.h"

@implementation timeFlowViewController

#pragma mark -
#pragma mark Constants

#define pageTop			65
#define barHeight		44
#define barWidth		768
#define labelHeight		21
#define labelWidth		748
#define labelLeftPad	20
#define rowPad			10

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



#pragma mark -
#pragma mark Event responsders

//
//-(IBAction) toggleTouchDown:(id)sender{
//	NSLog(@"toggleTouchDown");
//}
//-(IBAction) toggleTouchUpOutside:(id)sender{
//	NSLog(@"toggleTouchUpOutside");
//}
//-(IBAction) toggleTouchDragInside:(id)sender{
//	NSLog(@"toggleTouchDragInside");
//}
//-(IBAction) toggleTouchDragOutside:(id)sender{
//	NSLog(@"toggleTouchDragOutside");
//}


- (void) startClockTimer{
//	NSLog(@"startClockTimer");
/*
 Starts timer which fires updateClock method every 1.0 seconds
 */
	
	// scheduledTimerWithTimeInterval returns an autoreleased object
	clockTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(updateClock) userInfo: nil repeats: YES];	
}
- (void) updateClock{
// NSLog(@"updateClock");
/*
 Runs every 1.0 seconds
 Updates running timers' labels
 */

	NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[timeFormat setTimeStyle: NSDateFormatterMediumStyle];
	
	NUBICSelectableTimerButton *runningTimer;
	for (runningTimer in runningTimers){
		// NSLog(@"The following timer is running: %@", [runningTimer currentTitle]);
		// NSLog(@"%@", [timeFormat stringFromDate:[runningTimer startTime]]);
		
		unsigned int unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
		// currentCalendar returns an autoreleased object
		NSCalendar *gregorian = [NSCalendar currentCalendar];
		// components fromDate toDate returns an autoreleased object
		NSDateComponents *comps = [gregorian components:unitFlags fromDate:[runningTimer startTime]  toDate:[NSDate date]  options:0];

		// NSLog(@"%d:%02d", [comps minute], [comps second]);
		[runningTimer setTimeText:[NSString stringWithFormat:@"%d:%02d", [comps minute], [comps second]]];
	}
	
}

-(IBAction) toggleTouchUpInside:(id)sender{	
//	NSLog(@"toggleTouchUpInside");
/*
 Toggles label and startTime for button, add/removes it from runningTimers
 */
	
	NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[timeFormat setTimeStyle: NSDateFormatterMediumStyle];

	if (((NUBICSelectableTimerButton*)sender).selected) {
		((NUBICSelectableTimerButton*)sender).startTime = [NSDate date];
		[(NUBICSelectableTimerButton*)sender setTimeText:@"0:00"];
		[runningTimers addObject: sender];
	}else {
		[(NUBICSelectableTimerButton*)sender setStartTime:nil];
		[(NUBICSelectableTimerButton*)sender setTimeText:@""];
		[runningTimers removeObject: sender];
	}
}

#pragma mark -
#pragma mark View elements

- (UIView *)labelForBar:(int)barIndex withText:(NSString *)text {
//	NSLog(@"labelForBar %d %@", barIndex, text);
/*
 Return an autoreleased label for the bar with index barIndex
 */

    CGRect frame = CGRectMake(labelLeftPad, pageTop + ((labelHeight+barHeight+rowPad) * barIndex), labelWidth, labelHeight);
	// alloc
	UILabel *aLabel = [[UILabel alloc] initWithFrame:frame];
    aLabel.textAlignment = UITextAlignmentLeft;
	aLabel.textColor = [UIColor whiteColor];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = [UIFont systemFontOfSize:17.0];
    aLabel.userInteractionEnabled = NO;
    aLabel.text = text;
	// autorelease
	[aLabel autorelease];
    return aLabel;
}

- (UIToolbar *)barAtIndex:(int)barIndex {    
//	NSLog(@"barAtIndex %d", barIndex);
/*
 Return an autoreleased bar at index barIndex
 */

	// alloc
	UIToolbar *aBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, pageTop + labelHeight + ((labelHeight+barHeight+rowPad) * barIndex), barWidth, barHeight)];
	aBar.barStyle = UIBarStyleBlackOpaque;
	// autorelease
	[aBar autorelease];
    return aBar;
}


- (UIBarButtonItem *)toggleButtonWithTitle:(NSString *)title {
//	NSLog(@"toggleButtonWithTitle %@", title);
/*
 Return a autoreleased ui bar button item, with a custom view - nubic selectable timer button, with the given title
 */

	// alloc
	NUBICSelectableTimerButton *aButton = [[NUBICSelectableTimerButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) title:title];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:aButton];
	[aButton addTarget:self action:@selector(toggleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

	// release and autorelease
	[aButton release];
	[item autorelease];
	return item;
}


#pragma mark -
#pragma mark View Controller Configuration


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
										  
	// start the clock
	[self startClockTimer];
	
	// set up tool bar
	[super.view addSubview:[self labelForBar:0 withText:@"Location"]];
	UIToolbar *lBar = [self barAtIndex:0];
	[super.view addSubview: lBar];
	
	[super.view addSubview:[self labelForBar:1 withText:@"Communication: Face-to-face"]];
	UIToolbar *cfBar = [self barAtIndex:1];
	[super.view addSubview: cfBar];

	[super.view addSubview:[self labelForBar:2 withText:@"Communication: Phone"]];
	UIToolbar *cpBar = [self barAtIndex:2];
	[super.view addSubview: cpBar];

	[super.view addSubview:[self labelForBar:3 withText:@"Communication: Page"]];
	UIToolbar *cgBar = [self barAtIndex:3];
	[super.view addSubview: cgBar];

	[super.view addSubview:[self labelForBar:4 withText:@"Bedside care"]];
	UIToolbar *bcBar = [self barAtIndex:4];
	[super.view addSubview: bcBar];
	
	[super.view addSubview:[self labelForBar:5 withText:@"Documents: EMR"]];
	UIToolbar *deBar = [self barAtIndex:5];
	[super.view addSubview: deBar];

	[super.view addSubview:[self labelForBar:6 withText:@"Documents: Paper"]];
	UIToolbar *dpBar = [self barAtIndex:6];
	[super.view addSubview: dpBar];

	[super.view addSubview:[self labelForBar:7 withText:@"Indirect Care"]];
	UIToolbar *icBar = [self barAtIndex:7];
	[super.view addSubview: icBar];
	
	// titles
	NSArray *lButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"In room"],
						   [self toggleButtonWithTitle:@"Out of room"],
						   [self toggleButtonWithTitle:@"Nursing station"],
						   [self toggleButtonWithTitle:@"Rounds"],
						   [self toggleButtonWithTitle:@"Roadtrip"],
						   [self toggleButtonWithTitle:@"Breaks"],
						   [self toggleButtonWithTitle:@"Personal"],
						   nil];
	
	NSArray *cfButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Nurse"],
						   [self toggleButtonWithTitle:@"Doctor"],
						   [self toggleButtonWithTitle:@"Ancillary"],
						   [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						   [self toggleButtonWithTitle:@"Family"],
						   [self toggleButtonWithTitle:@"Patient"],
						  nil];

	NSArray *cpButtons = [NSArray arrayWithObjects:
						  [self toggleButtonWithTitle:@"Nurse"],
						  [self toggleButtonWithTitle:@"Doctor"],
						  [self toggleButtonWithTitle:@"Ancillary"],
						  [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						  [self toggleButtonWithTitle:@"Family"],
						  nil];

	NSArray *cgButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Nurse"],
						   [self toggleButtonWithTitle:@"Doctor"],
						   [self toggleButtonWithTitle:@"Ancillary"],
						   [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						  nil];
	
	NSArray *bcButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Hands-On"],
						   [self toggleButtonWithTitle:@"Non-Contact"],
						   [self toggleButtonWithTitle:@"Assessment"],
						   [self toggleButtonWithTitle:@"Other"],
						  nil];
	
	NSArray *deButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"MAR"],
						   [self toggleButtonWithTitle:@"To-Do/PAL"],
						   [self toggleButtonWithTitle:@"Orders"],
						   [self toggleButtonWithTitle:@"Pt Assessment"],
						   [self toggleButtonWithTitle:@"Flow"],
						   [self toggleButtonWithTitle:@"Review"],
						   [self toggleButtonWithTitle:@"Waiting"],
						   [self toggleButtonWithTitle:@"Other"],
						  nil];
	
	NSArray *dpButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Flow"],
						   [self toggleButtonWithTitle:@"CVVH"],
						   [self toggleButtonWithTitle:@"Rounding"],
						   [self toggleButtonWithTitle:@"Review"],
						   [self toggleButtonWithTitle:@"Other"],
						  nil];

	NSArray *icButtons = [NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Tele"],
						   [self toggleButtonWithTitle:@"Supply Gathering"],
						   [self toggleButtonWithTitle:@"Drug Gathering"],
						   [self toggleButtonWithTitle:@"Person Finding"],
						   [self toggleButtonWithTitle:@"Other"],
						   [self toggleButtonWithTitle:@"Internet"],
						  nil];
	
	// fill buttons array
	[lBar setItems:lButtons animated:NO ];
	[cfBar setItems:cfButtons animated:NO ];
	[cpBar setItems:cpButtons animated:NO ];
	[cgBar setItems:cgButtons animated:NO ];
	[bcBar setItems:bcButtons animated:NO ];
	[deBar setItems:deButtons animated:NO ];
	[dpBar setItems:dpButtons animated:NO ];
	[icBar setItems:icButtons animated:NO ];

	// running timers array
	runningTimers = [[NSMutableArray alloc] init];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}

@end
