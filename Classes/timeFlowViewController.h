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
	NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(IBAction) toggleTouchUpInside:(id)sender;

@end

