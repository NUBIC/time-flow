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
    [super viewDidLoad];

	// set up log box
	[logbox setTextColor:[UIColor whiteColor]];
	
	// set up tool bar
	UIToolbar *cBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 44.0)];
	cBar.barStyle = UIBarStyleBlackOpaque;
	[super.view addSubview:cBar];
	
	// button images
	offImage = [[UIImage imageNamed:@"grayBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	onImage = [[UIImage imageNamed:@"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];

	// titles
	NSArray* titles = [NSArray arrayWithObjects:
					    @"Nurse",
					    @"Doctor",
					    @"Ancillary Staff",
					    @"NonClinical Staff",
					    @"Family",
					    @"Patient",
					    nil];

	// empty buttons array
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:10 ];
	
	// creating buttons
	for (NSString* title in titles) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:title forState:UIControlStateNormal];
		[button sizeToFit];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
		[button setBackgroundImage:offImage forState:UIControlStateNormal];
		[button setBackgroundImage:onImage forState:UIControlStateHighlighted];
		[button addTarget:self action:@selector(pushed:) forControlEvents:UIControlEventTouchUpInside ];
		[buttons addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
//		[buttons addObject:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(pushed:) ]];
//		NSLog(@"%@", title);
		
	}
	
	// fill buttons array
	[cBar setItems:buttons animated:NO ];

}

-(IBAction) pushed:(id)sender{
//	NSLog(@"%@ at %@", [sender currentTitle], [NSDate date]);
//	NSLog(@"%@", [sender backgroundImageForState: UIControlStateNormal]);
	[self.logbox setText:[NSString stringWithFormat: @"%@ at %@", [((UIButton*)sender) currentTitle], [[NSDate date] description]]];
	
	if ([((UIButton*)sender) backgroundImageForState: UIControlStateNormal] == offImage) {
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

	}else {
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

	}

	
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
