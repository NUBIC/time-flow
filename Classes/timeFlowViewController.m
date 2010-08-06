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
#import "LogDetailViewController.h"

@implementation timeFlowViewController

@synthesize managedObjectContext=managedObjectContext_, scrollView, runningTimers, timersChanged, popoverController;

#pragma mark -
#pragma mark Constants

#define pageTop			0.0
#define barHeight		0.0
#define barWidth		768

#pragma mark -
#pragma mark Core data

-(NSArray *) runningEvents {
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"runningEvents"];
	
	// execute fetch request
	NSArray *timers = [[self.managedObjectContext executeFetchRequest:fetch error:&error] autorelease];
	if (!timers) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved runningTimer fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	return timers;
}
-(NSManagedObject *) runningEventForTimer:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn{
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
        NSLog(@"Unresolved runningTimer fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	return [timers lastObject];
}


-(void) saveContext:(NSString *)triggeredBy {
	// Save the context.
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved %@ error %@, %@", triggeredBy, error, [error userInfo]);
		abort();
	}
}

-(void) createEvent:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn {
	// Create a new event
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[newManagedObject setValue:timerTitle forKey:@"timerTitle"];
	[newManagedObject setValue:groupTitle forKey:@"groupTitle"];
	[newManagedObject setValue:startedOn forKey:@"startedOn"];
	[self saveContext:@"createEvent"];
}

-(void) closeEvent:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn {
	// Close an existing event
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
        NSLog(@"Unresolved runningTimer fetch error %@, %@", error, [error userInfo]);
        abort();
    }
	[[timers lastObject] setValue:[NSDate date] forKey:@"endedOn"];	
	
//	NSManagedObject *event = [self runningEventForTimer:timerTitle group:groupTitle startedOn:startedOn];
//	[event setValue:[NSDate date] forKey:@"endedOn"];
	[self saveContext:@"closeEvent"];
//	[event release];
}
-(void) deleteEevent:(NSString *)timerTitle group:(NSString *)groupTitle startedOn:(NSDate *)startedOn {
	[self.managedObjectContext deleteObject:[self runningEventForTimer:timerTitle group:groupTitle startedOn:startedOn]];
	[self saveContext:@"deleteEvent"];
}

#pragma mark -
#pragma mark Event responsders
-(IBAction) toggleTouchUpInside:(id)sender{	
	//	NSLog(@"toggleTouchUpInside");
	//	Toggles label and startTime for button, add/removes it from runningTimers

	NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[timeFormat setTimeStyle: NSDateFormatterMediumStyle];
	
	if (((NUBICSelectableTimerButton*)sender).selected) {
		((NUBICSelectableTimerButton*)sender).startTime = [NSDate date];
		[(NUBICSelectableTimerButton*)sender setTimeText:@"0:00"];
		[self createEvent:((NUBICSelectableTimerButton*)sender).timerTitle group:((NUBICSelectableTimerButton*)sender).groupTitle startedOn:((NUBICSelectableTimerButton*)sender).startTime];
		[runningTimers addObject: sender];
	}else {
		[self closeEvent:((NUBICSelectableTimerButton*)sender).timerTitle group:((NUBICSelectableTimerButton*)sender).groupTitle startedOn:((NUBICSelectableTimerButton*)sender).startTime];
		[(NUBICSelectableTimerButton*)sender setStartTime:nil];
		[(NUBICSelectableTimerButton*)sender setTimeText:@""];
		[runningTimers removeObject: sender];
	}
	//	NSLog(@"badge: %i", [runningTimers count]);
	if ([runningTimers count] > 0) {
		self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [runningTimers count]];
	}else {
		self.tabBarItem.badgeValue = nil;
	}
}
-(void) timerLongPress:(UIGestureRecognizer *)gestureRecognizer {
//	NSLog(@"longPress");
//	UIActionSheet *confirmation = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
//	[confirmation showInView:gestureRecognizer.view];
//	[confirmation showFromRect:CGRectMake(0.0, 0.0, 1.0, 1.0) inView:gestureRecognizer.view animated:YES];
	if([self.popoverController isPopoverVisible] || !((NUBICSelectableTimerButton *)[gestureRecognizer view]).selected)
	{
		//close the popover view if toolbar button was touched
		//again and popover is already visible
		//Thanks to @chrisonhismac
		
//		[self.popoverController dismissPopoverAnimated:YES];
		return;
	}
	
	//build our custom popover view
	UIViewController* popoverContent = [[UIViewController alloc] init];
	
	LogDetailViewController *logDetailView = [[LogDetailViewController alloc] init];	
	NUBICSelectableTimerButton *timerButton = (NUBICSelectableTimerButton *)gestureRecognizer.view;
	logDetailView.timerEvent = [self runningEventForTimer:timerButton.timerTitle group:timerButton.groupTitle startedOn:timerButton.startTime];
	popoverContent.view = logDetailView.view;
	
//	UIView* popoverView = [[UIView alloc]
//						   initWithFrame:CGRectMake(0, 0, 300, 400)];
//	popoverView.backgroundColor = [UIColor blackColor];
//	popoverContent.view = popoverView;
	
	//resize the popover view shown in the current view to the view's size
	popoverContent.contentSizeForViewInPopover = CGSizeMake(300, 400);
	
	//create a popover controller
	self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	
	//present the popover view non-modal with a
	//refrence to the toolbar button which was pressed
	[self.popoverController presentPopoverFromRect:CGRectMake(gestureRecognizer.view.frame.size.width/2, gestureRecognizer.view.frame.size.height/2 + 5.0, 1.0, 1.0) inView:gestureRecognizer.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	//release the popover content
	[logDetailView release];
//	[popoverView release];
	[popoverContent release];
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

#pragma mark -
#pragma mark Timers
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
#pragma mark View elements

- (NUBICSelectableTimerButton *)buttonWithTitle:(NSString *)title groupTitle:(NSString *)groupTitle borderColor:(UIColor *)borderColor {
	// autoreleased object
	NUBICSelectableTimerButton *aButton = [NUBICSelectableTimerButton buttonWithTitle:title groupTitle:groupTitle borderColor:borderColor];
	[aButton addTarget:self action:@selector(toggleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timerLongPress:)];
	[aButton addGestureRecognizer:longPress];
	return aButton;
}

- (void) populateTimers {	
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestTemplateForName:@"allTimerGroups"];
	
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
	int y = pageTop;
	
	// loop through timerGroups and Timers, create subviews
	for(NSManagedObject *group in groups){
		NUBICTimerBar *bar = [[NUBICTimerBar alloc] initWithFrame:CGRectMake(0.0, y, barWidth, barHeight)
															 text:[[group valueForKey:@"groupTitle"] description]];
		[[self scrollView] addSubview:bar];
		NSManagedObject *timer;
		NSSortDescriptor *byDisplayOrder = [[[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES] autorelease];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:byDisplayOrder, nil];
		for(timer in [[[group valueForKey:@"timers"] allObjects] sortedArrayUsingDescriptors:sortDescriptors]){
			[bar addSubview:[self buttonWithTitle:[[timer valueForKey:@"timerTitle"] description] groupTitle:[[group valueForKey:@"groupTitle"] description] borderColor:[timer valueForKey:@"borderColor"] ]];
		}
		[bar layoutSubviews];
		y += bar.frame.size.height;
		[bar release];
	}
	
	// resize scrollView
	[self scrollView].contentSize = CGSizeMake(768.0, y+5.0);
	
}

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
	[super dealloc];
}

@end
