//
//  timeFlowViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "timeFlowViewController.h"

@implementation timeFlowViewController

@synthesize logbox;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[logbox setTextColor:[UIColor whiteColor]];
    [super viewDidLoad];
	UIToolbar *cBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 44.0)];
	cBar.barStyle = UIBarStyleBlackOpaque;
	[super.view addSubview:cBar];
	UIImage *offImage = [[UIImage imageNamed:@"grayBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	UIImage *onImage = [[UIImage imageNamed:@"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	NSArray* titles = [NSArray arrayWithObjects:
					    @"Nurse",
					    @"Doctor",
					    @"Ancillary Staff",
					    @"NonClinical Staff",
					    @"Family",
					    @"Patient",
					    nil];
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:10 ];
	
	for (NSString* title in titles) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:title forState:UIControlStateNormal];
		[button sizeToFit];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[button setBackgroundImage:offImage forState:UIControlStateNormal];
		[button setBackgroundImage:onImage forState:UIControlStateHighlighted ];
		[button addTarget:self action:@selector(pushed:) forControlEvents:UIControlEventTouchUpInside ];
		[buttons addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
//		[buttons addObject:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(pushed:) ]];
		NSLog(@"%@", title);
		
	}
	[cBar setItems:buttons animated:NO ];

}

-(IBAction) pushed:(id)sender{
	NSLog(@"%@ at %@", [sender currentTitle], [NSDate date]);
	[self.logbox setText:[NSString stringWithFormat: @"%@ at %@", [sender currentTitle], [[NSDate date] description]]];
	
//	UIImage *onImage = [[UIImage imageNamed:@"blueSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
//	UIImage *offImage = [[UIImage imageNamed:@"graySegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
//	
//	if([[sender currentTitle] isEqualToString:@"Start"]){
//		[sender setTitle:@"Stop" forState:UIControlStateNormal];
//		[sender setBackgroundImage:onImage forState:UIControlStateNormal];
//	}
//	else {
//		[sender setTitle:@"Start" forState:UIControlStateNormal];
//		[sender setBackgroundImage:offImage forState:UIControlStateNormal];		
//	}
	
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
