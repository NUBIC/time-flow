//
//  LogViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 8/2/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>

@interface LogViewController : UITableViewController <NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate> {

@private
    Boolean changeIsUserDriven;
	NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)displayComposerSheet;


@end
