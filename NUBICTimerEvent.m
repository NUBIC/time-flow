//
//  NUBICTimerEvent.m
//  timeFlow
//
//  Created by Mark Yoon on 8/5/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "NUBICTimerEvent.h"


@implementation NUBICTimerEvent

@dynamic groupTitle, timerTitle, startedOn, endedOn;

- (NSString *)startedDate{
	if(!self.startedOn){ return @""; }
	NSDateFormatter *sdf = [[[NSDateFormatter alloc] init] autorelease];
	[sdf setDateFormat:@"yyyy-MM-dd"];
	return [sdf stringFromDate:self.startedOn];
}
- (NSString *)startedTime{
	if(!self.startedOn){ return @""; }
	NSDateFormatter *stf = [[[NSDateFormatter alloc] init] autorelease];
	[stf setDateFormat:@"H:mm:ss"];
	return [stf stringFromDate:self.startedOn];
}
- (NSString *)endedDate{
	if(!self.endedOn){ return @""; }
	NSDateFormatter *sdf = [[[NSDateFormatter alloc] init] autorelease];
	[sdf setDateFormat:@"yyyy-MM-dd"];
	return [sdf stringFromDate:self.endedOn];
}
- (NSString *)endedTime{
	if(!self.endedOn){ return @""; }
	NSDateFormatter *stf = [[[NSDateFormatter alloc] init] autorelease];
	[stf setDateFormat:@"H:mm:ss"];
	return [stf stringFromDate:self.endedOn];	
}
- (NSString *)duration{
	if(!self.startedOn && !self.endedOn){
		return @"";
	}else {
		return [NSString stringWithFormat:@"%i", (int)[self.endedOn timeIntervalSinceDate:self.startedOn]];
	}
}

@end
