//
//  NUBICTimerBar.m
//  timeFlow
//
//  Created by Mark Yoon on 7/29/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "NUBICTimerBar.h"

#define button_x_padding 4.0
#define button_y_padding 4.0
#define group_x_padding 4.0
#define group_y_padding 2.0

#define label_height		20.0
#define label_width		758.0

@implementation NUBICTimerBar

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		// alloc
		UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(group_x_padding, 0.0, label_width, label_height)];
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
	CGFloat x = group_x_padding, y = group_y_padding;
	CGFloat maxX = 0, rowHeight = 0;
	CGFloat maxWidth = self.frame.size.width - (group_x_padding * 2);
	for (UIView* subview in self.subviews) {
		if (x + subview.frame.size.width > maxWidth) {
			x = group_x_padding;
			y += rowHeight + button_y_padding;
			rowHeight = 0;
		}
		subview.frame = CGRectMake(x, y, subview.frame.size.width, subview.frame.size.height);
		x += subview.frame.size.width + button_x_padding;
		maxX = MAX(x, maxX);
		rowHeight = MAX(subview.frame.size.height, rowHeight);
	}
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxX, y+rowHeight);
//	NSLog(@"x:%f y:%f w:%f h:%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)dealloc {
    [super dealloc];
}


@end
