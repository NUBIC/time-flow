//
//  DetailViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/28/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "itemInputController.h"
#import "timeFlowAppDelegate.h"

#define UIAppDelegate ((timeFlowAppDelegate *)[UIApplication sharedApplication].delegate)

@interface setupDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate, itemInputControllerDelegate, UISplitViewControllerDelegate> {
	
	itemInputController *inputController;
	NSManagedObject *timerGroup;
	
@private
    Boolean changeIsUserDriven;
	NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObject *timerGroup;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
