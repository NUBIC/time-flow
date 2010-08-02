//
//  NUBICSelectableTimerButton.h
//  timeFlow
//
//  Created by Mark Yoon on 7/15/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//
//  Inspiration from http://www.iphonedevsdk.com/forum/iphone-sdk-development/15318-how-configure-custom-uibutton-subclass-respond-its-own-touchupinside-event.html


#import <UIKit/UIKit.h>


@interface NUBICSelectableTimerButton : UIButton {
	UILabel *time;
	NSString *timerTitle;
	NSString *groupTitle;
	NSDate *startTime;
}

@property (nonatomic, retain) NSString *timerTitle;
@property (nonatomic, retain) NSString *groupTitle;
@property (nonatomic, retain) NSDate *startTime;

- (id)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)setTimeText:(NSString *)str;

@end
