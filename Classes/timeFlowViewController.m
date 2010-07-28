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

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

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
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimerGroup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    

- (void) populateTimers {
	NSArray *groups = [self.fetchedResultsController fetchedObjects];
	int i = 0;
	NSManagedObject *group;
	for(group in groups){
		[super.view addSubview:[self labelForBar:i withText:[[group valueForKey:@"groupTitle"] description]]];
		UIToolbar *bar = [self barAtIndex:i];
		[super.view addSubview:bar];
		i++;

		NSMutableArray *buttons = [[NSMutableArray alloc] init];
		NSManagedObject *timer;
		for(timer in [group valueForKey:@"timers"]){
			[buttons addObject:[self toggleButtonWithTitle:[[timer valueForKey:@"timerTitle"] description]]];
		}
		[bar setItems:buttons animated:NO];	
	}
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
}

// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// populate the timers
	[self populateTimers];

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

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


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
