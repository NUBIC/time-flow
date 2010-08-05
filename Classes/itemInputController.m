    //
//  itemInputController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/27/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "itemInputController.h"

@implementation itemInputController

@synthesize delegate, textField, highlightSwitch, navItem, inputType;
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
	if (!self.inputType) {
		self.inputType = @"Item";
	}else if (self.inputType != @"Timer") {
		highlightSwitch.hidden = YES;
	}
	
	UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 21.0)];
	aLabel.textAlignment = UITextAlignmentLeft;
	aLabel.textColor = [UIColor blackColor];
	aLabel.backgroundColor = [UIColor clearColor];
	aLabel.font = [UIFont boldSystemFontOfSize:16.0];
	aLabel.userInteractionEnabled = NO;
	aLabel.text = @"Title";
	textField.font = [UIFont systemFontOfSize:16.0];
	textField.leftView = aLabel;
	textField.leftViewMode = UITextFieldViewModeAlways;
	textField.placeholder = [NSString stringWithFormat:@"%@ Title", self.inputType];
	[aLabel release];
	navItem.title = [NSString stringWithFormat:@"New %@", inputType];
	[textField becomeFirstResponder];
}


- (IBAction)doneButtonPressed:(id)sender{
	if (self.inputType == @"Timer") {
		[self.delegate itemInputController:self didAddItem:textField.text highlight:highlightSwitch.on];
	}else {
		[self.delegate itemInputController:self didAddItem:textField.text];
	}
}
- (IBAction)cancelButtonPressed:(id)sender{
	if (self.inputType == @"Timer") {
		[self.delegate itemInputController:self didAddItem:@"" highlight:NO];
	}else {
		[self.delegate itemInputController:self didAddItem:@""];
	}
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textField release];
    [super dealloc];
}


@end

