//
//  timeFlowViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import "timeFlowViewController.h"

@implementation timeFlowViewController

@synthesize logbox;

#define pageTop			65.0
#define barHeight		44.0
#define barWidth		768.0
#define labelHeight		21.0
#define labelWidth		748.0
#define labelLeftPad	20.0
#define rowPad			10.0

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
#pragma mark View elements

- (UIView *)labelForBar:(CGFloat)barIndex withText:(NSString *)text {    
    /*
     Return a label for the bar with index barIndex
     */
    CGRect frame = CGRectMake(labelLeftPad, pageTop + ((labelHeight+barHeight+rowPad) * barIndex), labelWidth, labelHeight);
    UILabel *aLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    aLabel.textAlignment = UITextAlignmentLeft;
	aLabel.textColor = [UIColor whiteColor];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = [UIFont systemFontOfSize:17.0];
    aLabel.userInteractionEnabled = NO;
    aLabel.text = text;
    return aLabel;
}

- (UIToolbar *)barAtIndex:(CGFloat)barIndex {    
    /*
     Return a bar at index barIndex
     */
	UIToolbar *aBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, pageTop + labelHeight + ((labelHeight+barHeight+rowPad) * barIndex), barWidth, barHeight)] autorelease];
	aBar.barStyle = UIBarStyleBlackOpaque;
    return aBar;
}

- (UIBarButtonItem *)toggleButtonWithTitle:(NSString *)title {
	UIButton *aButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] autorelease];
	[aButton setTitle:title forState:UIControlStateNormal];
	[aButton sizeToFit];
	[aButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[aButton setBackgroundImage:offImage forState:UIControlStateNormal];
	[aButton setBackgroundImage:onImage forState:UIControlStateHighlighted];
	[aButton addTarget:self action:@selector(toggleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:aButton];
	return item;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	// set up log box
	[logbox setTextColor:[UIColor whiteColor]];

	// button images
	offImage = [[UIImage imageNamed:@"grayBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	onImage = [[UIImage imageNamed:@"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	
	// set up tool bar
	[super.view addSubview:[self labelForBar:0.0 withText:@"Location"]];
	UIToolbar *lBar = [self barAtIndex:0.0];
	[super.view addSubview: lBar];
	
	[super.view addSubview:[self labelForBar:1.0 withText:@"Communication: Face-to-face"]];
	UIToolbar *cfBar = [self barAtIndex:1.0];
	[super.view addSubview: cfBar];

	[super.view addSubview:[self labelForBar:2.0 withText:@"Communication: Phone"]];
	UIToolbar *cpBar = [self barAtIndex:2.0];
	[super.view addSubview: cpBar];

	[super.view addSubview:[self labelForBar:3.0 withText:@"Communication: Page"]];
	UIToolbar *cgBar = [self barAtIndex:3.0];
	[super.view addSubview: cgBar];

	[super.view addSubview:[self labelForBar:4.0 withText:@"Bedside care"]];
	UIToolbar *bcBar = [self barAtIndex:4.0];
	[super.view addSubview: bcBar];
	
	[super.view addSubview:[self labelForBar:5.0 withText:@"Documents: EMR"]];
	UIToolbar *deBar = [self barAtIndex:5.0];
	[super.view addSubview: deBar];

	[super.view addSubview:[self labelForBar:6.0 withText:@"Documents: Paper"]];
	UIToolbar *dpBar = [self barAtIndex:6.0];
	[super.view addSubview: dpBar];

	[super.view addSubview:[self labelForBar:7.0 withText:@"Indirect Care"]];
	UIToolbar *icBar = [self barAtIndex:7.0];
	[super.view addSubview: icBar];
	
	// titles
	NSArray *lButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"In room"],
						   [self toggleButtonWithTitle:@"Out of room"],
						   [self toggleButtonWithTitle:@"Nursing station"],
						   [self toggleButtonWithTitle:@"Rounds"],
						   [self toggleButtonWithTitle:@"Roadtrip"],
						   [self toggleButtonWithTitle:@"Breaks"],
						   [self toggleButtonWithTitle:@"Personal"],
						   nil] autorelease];
	
	NSArray *cfButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Nurse"],
						   [self toggleButtonWithTitle:@"Doctor"],
						   [self toggleButtonWithTitle:@"Ancillary"],
						   [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						   [self toggleButtonWithTitle:@"Family"],
						   [self toggleButtonWithTitle:@"Patient"],
						   nil] autorelease];

	NSArray *cpButtons = [[NSArray arrayWithObjects:
						  [self toggleButtonWithTitle:@"Nurse"],
						  [self toggleButtonWithTitle:@"Doctor"],
						  [self toggleButtonWithTitle:@"Ancillary"],
						  [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						  [self toggleButtonWithTitle:@"Family"],
						  nil] autorelease];

	NSArray *cgButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Nurse"],
						   [self toggleButtonWithTitle:@"Doctor"],
						   [self toggleButtonWithTitle:@"Ancillary"],
						   [self toggleButtonWithTitle:@"Non-Clinical Staff"],
						   nil] autorelease];
	
	NSArray *bcButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Hands-On"],
						   [self toggleButtonWithTitle:@"Non-Contact"],
						   [self toggleButtonWithTitle:@"Assessment"],
						   [self toggleButtonWithTitle:@"Other"],
						   nil] autorelease];
	
	NSArray *deButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"MAR"],
						   [self toggleButtonWithTitle:@"To-Do/PAL"],
						   [self toggleButtonWithTitle:@"Orders"],
						   [self toggleButtonWithTitle:@"Pt Assessment"],
						   [self toggleButtonWithTitle:@"Flow"],
						   [self toggleButtonWithTitle:@"Review"],
						   [self toggleButtonWithTitle:@"Waiting"],
						   [self toggleButtonWithTitle:@"Other"],
						   nil] autorelease];
	
	NSArray *dpButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Flow"],
						   [self toggleButtonWithTitle:@"CVVH"],
						   [self toggleButtonWithTitle:@"Rounding"],
						   [self toggleButtonWithTitle:@"Review"],
						   [self toggleButtonWithTitle:@"Other"],
						   nil] autorelease];

	NSArray *icButtons = [[NSArray arrayWithObjects:
						   [self toggleButtonWithTitle:@"Tele"],
						   [self toggleButtonWithTitle:@"Supply Gathering"],
						   [self toggleButtonWithTitle:@"Drug Gathering"],
						   [self toggleButtonWithTitle:@"Person Finding"],
						   [self toggleButtonWithTitle:@"Other"],
						   [self toggleButtonWithTitle:@"Internet"],
						   nil] autorelease];
	
	// fill buttons array
	[lBar setItems:lButtons animated:NO ];
	[cfBar setItems:cfButtons animated:NO ];
	[cpBar setItems:cpButtons animated:NO ];
	[cgBar setItems:cgButtons animated:NO ];
	[bcBar setItems:bcButtons animated:NO ];
	[deBar setItems:deButtons animated:NO ];
	[dpBar setItems:dpButtons animated:NO ];
	[icBar setItems:icButtons animated:NO ];

	
}
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

-(IBAction) toggleTouchUpInside:(id)sender{
//	NSLog(@"toggleTouchUpInside");
//	NSLog(@"%@ at %@", [sender currentTitle], [NSDate date]);
	[self.logbox setText:[NSString stringWithFormat: @"%@ at %@", [((UIButton*)sender) currentTitle], [[NSDate date] description]]];
	
	if ([((UIButton*)sender) backgroundImageForState: UIControlStateHighlighted] == onImage) {
		// the button is currently "off"
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
		[self.logbox setText:[NSString stringWithFormat: @"%@ ON at %@", [((UIButton*)sender) currentTitle], [[NSDate date] description]]];
	}else {
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[self.logbox setText:[NSString stringWithFormat: @"%@ OFF at %@", [((UIButton*)sender) currentTitle], [[NSDate date] description]]];
	}
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
