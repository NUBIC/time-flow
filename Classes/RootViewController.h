//
//  RootViewController.h
//  coredataproject
//
//  Created by Mark Yoon on 7/23/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "itemInputController.h"


@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, itemInputControllerDelegate> {
	// http://stackoverflow.com/questions/1664724/objective-c-double-delegate-protocol	
	itemInputController *inputController;

@private
    Boolean changeIsUserDriven;
	NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
