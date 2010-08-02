//
//  timeFlowViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface timeFlowViewController : UIViewController <NSFetchedResultsControllerDelegate> {
	NSTimer *clockTimer;
	NSMutableArray *runningTimers;

@private
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSMutableArray *runningTimers;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

-(IBAction) toggleTouchUpInside:(id)sender;

@end

