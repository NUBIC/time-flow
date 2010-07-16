//
//  NUBICSelectableTimerButton.h
//  timeFlow
//
//  Created by Mark Yoon on 7/15/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NUBICSelectableTimerButton : UIButton {
	UILabel *time;
	
}

//@property (assign) UILabel *time;
- (id)initWithFrame: (CGRect)frame andTitle: (NSString*)title;
- (void)setTimeText: (NSString *)str;
//- (id)getTimeText;

@end
