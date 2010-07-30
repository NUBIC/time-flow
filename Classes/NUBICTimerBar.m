//
//  NUBICTimerBar.m
//  timeFlow
//
//  Created by Mark Yoon on 7/29/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "NUBICTimerBar.h"

#define _padding	5.0
#define _spacing	5.0
#define labelHeight		21.0
#define labelWidth		758.0
#define labelLeftPad	0.0

@implementation NUBICTimerBar

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		// alloc
		UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftPad, 0.0, labelWidth, labelHeight)];
		aLabel.textAlignment = UITextAlignmentLeft;
		aLabel.textColor = [UIColor whiteColor];
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.font = [UIFont systemFontOfSize:17.0];
		aLabel.userInteractionEnabled = NO;
		aLabel.text = text;
		[self addSubview:aLabel];
		[aLabel release];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setItems:(NSArray *)buttons animated:(Boolean)animated {
//	NSLog(@"setItems");
	UIView *button;
	for(button in buttons){
		[self addSubview:button];
	}
}

- (void)layoutSubviews {
//	NSLog(@"subviews: %@", self.subviews);
	CGFloat x = _padding, y = _padding;
	CGFloat maxX = 0, lastHeight = 0;
	CGFloat maxWidth = self.frame.size.width - _padding*2;
	for (UIView* subview in self.subviews) {
//		NSLog(@"x %f, y %f, maxX %f, lastHeight %f, maxWidth %f", x, y, maxX, lastHeight, maxWidth);
		if (x + subview.frame.size.width > maxWidth) {
			x = _padding;
			y += lastHeight + _spacing;
		}
		subview.frame = CGRectMake(x, y, subview.frame.size.width, subview.frame.size.height);
		x += subview.frame.size.width + _spacing;
		if (x > maxX) {
			maxX = x;
		}
		lastHeight = subview.frame.size.height;
	}
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxX+_padding, y+lastHeight+_padding);
}

- (void)dealloc {
    [super dealloc];
}


@end
