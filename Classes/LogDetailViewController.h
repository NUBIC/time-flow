//
//  LogDetailViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 8/5/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUBICTimerEvent.h"

@interface LogDetailViewController : UIViewController {
	NUBICTimerEvent *timerEvent;
	UILabel *groupTitle;
	UILabel *timerTitle;
	UILabel *startedOn;
	UILabel *endedOn;
	
}

@property (nonatomic, retain) NUBICTimerEvent *timerEvent;
@property (nonatomic, retain) IBOutlet UILabel *groupTitle;
@property (nonatomic, retain) IBOutlet UILabel *timerTitle;
@property (nonatomic, retain) IBOutlet UILabel *startedOn;
@property (nonatomic, retain) IBOutlet UILabel *endedOn;

@end
