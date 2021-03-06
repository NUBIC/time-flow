//
//  NUBICSelectableTimerButton.m
//  timeFlow
//
//  Created by Mark Yoon on 7/15/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "NUBICSelectableTimerButton.h"



@implementation NUBICSelectableTimerButton

@synthesize timerTitle, groupTitle, startTime, borderColor;

#pragma mark -
#pragma mark Constants

#define padWidth	10
#define minHeight	44

- (id)initWithFrame:(CGRect)frame title:(NSString*)title borderColor:(UIColor *)bColor {
	if (self = [super initWithFrame: frame])
	{
		// Create background images
		UIImage* normalImage = [[UIImage imageNamed: @"grayBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
		//		UIImage* downImage = [[UIImage imageNamed: @"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
		UIImage* selectedImage = [[UIImage imageNamed: @"blueBlackSegment.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
		
		// Set title
		self.timerTitle = title;
		[self setTitle: title forState: UIControlStateNormal];	// Will be used for all states
		[self setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
//		[self setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
		[self setTitleColor: [UIColor whiteColor] forState:UIControlStateSelected];
//		self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 13.0, 0.0);

		// Set background images
		[self setBackgroundImage: normalImage forState: UIControlStateNormal];
		//		[self setBackgroundImage: downImage forState: UIControlStateHighlighted];
		[self setBackgroundImage: selectedImage forState: UIControlStateSelected];
		
		self.borderColor = bColor;

		// Set target
		[self addTarget: self action: @selector(button_clicked:) forControlEvents: UIControlEventTouchUpInside];
		
		// Sizing
		[self sizeToFit];
		
		CGSize minSize = CGSizeMake(MAX([@"00:00:00" sizeWithFont:[UIFont systemFontOfSize:14.0]].width, self.frame.size.width) + padWidth, 
									MAX(minHeight, self.frame.size.height));
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, minSize.width, minSize.height);

		// Time label
		time = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, minSize.width, self.frame.size.height-20.0)];
		time.textAlignment = UITextAlignmentCenter;
		time.textColor = [UIColor darkGrayColor];
		time.backgroundColor = [UIColor clearColor];
		time.font = [UIFont systemFontOfSize:14.0];
		time.userInteractionEnabled = NO;
		time.text = @"";
		
		startTime = nil;
		
		[self addSubview:time];
		
	}
	
	return self;
}
- (void)startTimer {
	self.startTime = [NSDate date];
	[self setTimeText:@"0:00"];
}
- (void)stopTimer {
	self.startTime = nil;
	[self setTimeText:@""];
}

- (void)setTimeText:(NSString *)str {
	if([str length]){
		self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 13.0, 0.0);
	}else {
		self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	}
	time.text = str;
}

- (void)button_clicked: (id)sender
{
	self.selected = !self.selected;
}
- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame title:@"Button" borderColor:nil];
}
+ (id)buttonWithTitle:(NSString *)title groupTitle:(NSString *)groupTitle borderColor:(UIColor *)borderColor {
	// NSLog(@"buttonWithTitle %@", title);
	// Return a autoreleased button
	
	NUBICSelectableTimerButton *aButton = [[[self alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) title:title borderColor:borderColor] autorelease];
	aButton.groupTitle = groupTitle;
	return aButton;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	if (self.borderColor) {
		// Set the layer's corner radius
		[[self layer] setCornerRadius:8.0f];
		
		// Turn on masking
		[[self layer] setMasksToBounds:YES];
		
		// Display a border around the button 
		[[self layer] setBorderWidth:3.0f];
		[[self layer] setBorderColor:[self.borderColor CGColor]];		
	}

	[super drawRect:rect];
}

- (void)dealloc {
	[timerTitle release];
	[groupTitle release];
	[startTime release];
	[borderColor release];
	
    [super dealloc];
}


@end
