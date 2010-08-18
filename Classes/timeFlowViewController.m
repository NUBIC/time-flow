//
//  timeFlowViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import "timeFlowViewController.h"
#import "NUBICSelectableTimerButton.h"
#import "NUBICTimerBar.h"
#import "timerOptionsViewController.h"
#import "timeFlowAppDelegate.h"

@implementation timeFlowViewController

@synthesize managedObjectContext=managedObjectContext_, scrollView, navBar, runningTimers, timersChanged; //, popoverController;

#pragma mark -
#pragma mark Badge
-(void) updateBadge {
	//	NSLog(@"updateBadge: %i", [runningTimers count]);
	self.tabBarItem.badgeValue = [runningTimers count] > 0 ? [NSString stringWithFormat:@"%i", [runningTimers count]] : nil;
}


#pragma mark -
#pragma mark Core data

-(NUBICTimerEvent *) runningEventForTimer:(NSString *)timerTitle group:(NSString *)groupTitle {
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"runningEvents" 
		substitutionVariables:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:timerTitle, groupTitle, nil] 
														  forKeys:[NSArray arrayWithObjects: @"timerTitle", @"groupTitle", nil]]];
	
	NSArray *sortDescriptors = [NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"startedOn" ascending:YES] autorelease], nil];
	[fetch setSortDescriptors:sortDescriptors];
	
	// http://coderslike.us/2009/05/05/finding-freeddeallocated-instances-of-objects/
	// execute fetch request
	NSArray *events = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!events) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved runningEventForTimer fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	return [events lastObject];
}
-(NUBICTimerEvent *) runningEventForTimer:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn{
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"runningEvent" substitutionVariables:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:timerTitle, groupTitle, startedOn, nil] forKeys:[NSArray arrayWithObjects: @"timerTitle", @"groupTitle", @"startedOn", nil]]];
	
	// execute fetch request
	NSArray *timers = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!timers || [timers count] != 1) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved runningEventForTimer fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	return [timers lastObject];
}
-(void) createEvent:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn {
	// Create a new event
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[newManagedObject setValue:timerTitle forKey:@"timerTitle"];
	[newManagedObject setValue:groupTitle forKey:@"groupTitle"];
	[newManagedObject setValue:startedOn forKey:@"startedOn"];
	[UIAppDelegate saveContext:@"createEvent"];
}

-(void) closeEvent:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn {
	[[self runningEventForTimer:timerTitle group:groupTitle startedOn:startedOn] setValue:[NSDate date] forKey:@"endedOn"];	
	[UIAppDelegate saveContext:@"closeEvent"];
}
-(void) deleteEvent:(NUBICSelectableTimerButton *)timer {
	[runningTimers removeObject:timer];
	[self.managedObjectContext deleteObject:[self runningEventForTimer:timer.timerTitle group:timer.groupTitle startedOn:timer.startTime]];
	[timer stopTimer];
	[self updateBadge];
	currentActionTimer.selected = NO;
	currentActionTimer = nil;
	[UIAppDelegate saveContext:@"deleteEvent"];
}

#pragma mark -
#pragma mark Event responsders
-(void) toggleTouchUpInside:(id)sender{	
//	NSLog(@"toggleTouchUpInside");
	NUBICSelectableTimerButton *timer = (NUBICSelectableTimerButton *)sender;
	
	if (swappingTimers) {
		[timer startTimer];
		timer.startTime = currentActionTimer.startTime;
		[self createEvent:timer.timerTitle group:timer.groupTitle startedOn:currentActionTimer.startTime];
		[runningTimers addObject:timer];
		
		for (NUBICSelectableTimerButton *runningTimer in runningTimers) {
			runningTimer.enabled = YES;
		}

		[self deleteEvent:currentActionTimer];
		swappingTimers = NO;
	}else {
		if (timer.selected) {
			[timer startTimer];
			[self createEvent:timer.timerTitle group:timer.groupTitle startedOn:timer.startTime];
			[runningTimers addObject: timer];
		}else {
			[runningTimers removeObject:timer];
			[self closeEvent:timer.timerTitle group:timer.groupTitle startedOn:timer.startTime];
			[timer stopTimer];
		}
	}
	[self updateBadge];
}
-(void) timerLongPress:(UIGestureRecognizer *)gestureRecognizer {
//	NSLog(@"longPress");
	if(gestureRecognizer.state == UIGestureRecognizerStateBegan && ((NUBICSelectableTimerButton *)gestureRecognizer.view).selected){
		// NSLog(@"longPress state began on button that is selected");
		UIActionSheet *confirmation = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Swap", nil];
		[confirmation showFromRect:gestureRecognizer.view.bounds inView:gestureRecognizer.view animated:NO];
		[confirmation release];
		currentActionTimer = (NUBICSelectableTimerButton *)gestureRecognizer.view;
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.destructiveButtonIndex) {
		[self deleteEvent:currentActionTimer];
	}else if (buttonIndex == 1) {
		// NSLog(@"swap");
		swappingTimers = YES;
		for (NUBICSelectableTimerButton *runningTimer in runningTimers) {
			runningTimer.enabled = NO;
		}
	}else if (buttonIndex == 2) {
		// add note
		NSLog(@"Add Note");
	}
	
}

#pragma mark -
#pragma mark Updating timer views
- (void) startClockTimer{
// NSLog(@"startClockTimer");
// Starts timer which fires updateClock method every 1.0 seconds

	// scheduledTimerWithTimeInterval returns an autoreleased object
	clockTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(updateClock) userInfo: nil repeats: YES];	
}
- (void) updateClock{
// NSLog(@"updateClock");
// Updates running timers' labels

	NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[timeFormat setTimeStyle:NSDateFormatterMediumStyle];
	
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


#pragma mark -
#pragma mark Creating timer views
- (NUBICSelectableTimerButton *)buttonWithTitle:(NSString *)title groupTitle:(NSString *)groupTitle borderColor:(UIColor *)borderColor {
	// autoreleased object
	NUBICSelectableTimerButton *aButton = [NUBICSelectableTimerButton buttonWithTitle:title groupTitle:groupTitle borderColor:borderColor];
	[aButton addTarget:self action:@selector(toggleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timerLongPress:)];
	[aButton addGestureRecognizer:longPress];
	[longPress release];
	return aButton;
}

- (void) populateTimers {	
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestTemplateForName:@"allTimerGroups"];
	
	// sort
	NSArray *sortDescriptors = [NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES] autorelease], nil];
	[fetch setSortDescriptors:sortDescriptors];
	
	// execute fetch request
	NSArray *groups = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!groups) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved allTimerGroups fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	
	// clear scrollview
	for (UIView *sub in [self.scrollView subviews]) {
		[sub removeFromSuperview];
	}
	float y = 0.0;
	
	// loop through timerGroups and Timers, create subviews
	for(NSManagedObject *group in groups){
		NUBICTimerBar *bar = [[NUBICTimerBar alloc] initWithFrame:CGRectMake(0, y, 768, 65) text:[[group valueForKey:@"groupTitle"] description]];
		for(NSManagedObject *timer in [[[group valueForKey:@"timers"] allObjects] sortedArrayUsingDescriptors:sortDescriptors]){
			NUBICSelectableTimerButton *button = [self buttonWithTitle:[[timer valueForKey:@"timerTitle"] description] groupTitle:[[group valueForKey:@"groupTitle"] description] borderColor:[timer valueForKey:@"borderColor"]];
			[bar addSubview: button];

			// start timer if there is an existing event
			NUBICTimerEvent *existingEvent = [self runningEventForTimer:[[timer valueForKey:@"timerTitle"] description] group:[[group valueForKey:@"groupTitle"] description]];
			if (existingEvent) {
				NSLog(@"existing event");
				[button startTimer];
				button.startTime = existingEvent.startedOn;
				button.selected = YES;
				[runningTimers addObject:button];
			}
		}
		[bar layoutSubviews];
		[self.scrollView addSubview:bar];

		y += bar.frame.size.height;
		// NSLog(@"y: %f", y);
	}
	
	// resize scrollView
	[self scrollView].contentSize = CGSizeMake(768.0, y+5.0);
}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// start the clock
	[self startClockTimer];
	
	// running timers array
	runningTimers = [[NSMutableArray alloc] init];
	
	// populate the timers
	[self populateTimers];
}

// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
//	NSLog(@"timeFlowViewController viewWillAppear");
    [super viewWillAppear:animated];

	if (timersChanged) {
		// populate the timers
		[self populateTimers];
		self.timersChanged = NO;
	}
}


/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Memory management

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
	[managedObjectContext_ release];

	[scrollView release];
	[navBar release];
	[runningTimers release];
	[super dealloc];
}

@end
