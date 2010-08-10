//
//  timeFlowViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NUBICSelectableTimerButton.h"

@interface timeFlowViewController : UIViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate> {
	UIScrollView *scrollView;
	UINavigationBar *navBar;

	NSMutableArray *runningTimers;
	Boolean timersChanged;

	NSTimer *clockTimer;
	NUBICSelectableTimerButton *currentActionTimer;
	Boolean swappingTimers;

@private
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) NSMutableArray *runningTimers;
@property (nonatomic, assign) Boolean timersChanged;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

