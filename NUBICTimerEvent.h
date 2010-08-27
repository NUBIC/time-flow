//
//  NUBICTimerEvent.h
//  timeFlow
//
//  Created by Mark Yoon on 8/5/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NUBICTimerEvent : NSManagedObject {

}

@property (nonatomic, assign) NSString *groupTitle;
@property (nonatomic, assign) NSString *timerTitle;
@property (nonatomic, assign) NSDate *startedOn;
@property (nonatomic, assign) NSDate *endedOn;
@property (nonatomic, assign) NSString *eventNote;

- (NSString *)startedDate;
- (NSString *)startedTime;
- (NSString *)endedDate;
- (NSString *)endedTime;
- (NSString *)duration;
- (NSString *)note;

@end
