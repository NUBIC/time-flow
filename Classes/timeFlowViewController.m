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
    CGRect frame = CGRectMake(20.0, 44.0 + ((21.0+44.0) * barIndex), 748.0, 21.0);
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
	UIToolbar *aBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 65.0 + ((21.0+44.0) * barIndex), 768.0, 44.0)] autorelease];
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
	
	// set up tool bar
	[super.view addSubview:[self labelForBar:0.0 withText:@"Communication"]];
	UIToolbar *cBar = [self barAtIndex:0.0];
	[super.view addSubview: cBar];
	
	// button images
	offImage = [[UIImage imageNamed:@"grayBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
	onImage = [[UIImage imageNamed:@"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];

	// titles
	NSArray *cButtons = [[NSArray arrayWithObjects:
						 [self toggleButtonWithTitle:@"Nurse"],
						 [self toggleButtonWithTitle:@"Doctor"],
						 [self toggleButtonWithTitle:@"Ancillary"],
						 [self toggleButtonWithTitle:@"NonClinical Staff"],
						 [self toggleButtonWithTitle:@"Family"],
						 [self toggleButtonWithTitle:@"Patient"],
						 nil] autorelease];

	// fill buttons array
	[cBar setItems:cButtons animated:NO ];

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
	NSLog(@"toggleTouchUpInside");
//	NSLog(@"%@ at %@", [sender currentTitle], [NSDate date]);
//	NSLog(@"%@", [sender backgroundImageForState: UIControlStateNormal]);
	[self.logbox setText:[NSString stringWithFormat: @"%@ at %@", [((UIButton*)sender) currentTitle], [[NSDate date] description]]];
	
	if ([((UIButton*)sender) backgroundImageForState: UIControlStateHighlighted] == onImage) {
		// the button is currently "off"
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

	}else {
		[((UIButton*)sender) setBackgroundImage:offImage forState:UIControlStateNormal];
		[((UIButton*)sender) setBackgroundImage:onImage forState:UIControlStateHighlighted ];
		[((UIButton*)sender) setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[((UIButton*)sender) setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

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
