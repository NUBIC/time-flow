//
//  RootViewController.m
//  coredataproject
//
//  Created by Mark Yoon on 7/23/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "setupRootViewController.h"
#import "setupDetailViewController.h"
#import "timeFlowAppDelegate.h"

@implementation setupRootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark Core Data
-(NSManagedObject *) timerGroupWithTitle:(NSString *)groupTitle {
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"timerGroupWithTitle" substitutionVariables:[NSDictionary dictionaryWithObject:groupTitle forKey:@"groupTitle"]];
							 
	// execute fetch request
	NSArray *groups = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!groups || [groups count] != 1) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved timerGroupWithTitle fetch error %@, %@", error, [error userInfo]);
		abort();
	}
	return [groups lastObject];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelectionDuringEditing = YES;
	self.clearsSelectionOnViewWillAppear = NO;

//	NSLog(@"RootViewController moc: %@", self.managedObjectContext);
    // Set up the edit and add buttons.
    [self setToolbarItems:[NSArray arrayWithObject:self.editButtonItem]];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
	self.navigationItem.title = [NSString stringWithFormat:@"Groups (%d)", [[self.fetchedResultsController fetchedObjects] count]];
    [addButton release];
}

/*
// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"groupTitle"] description];
	if ([[[managedObject valueForKey:@"timers"] allObjects] count] != 0) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} 
	
}


#pragma mark -
#pragma mark itemInputControllerDelegate

- (void)insertNewObject {
	inputController = [[itemInputController alloc] init];
	inputController.delegate = self;
	inputController.modalPresentationStyle = UIModalPresentationFormSheet;
	inputController.inputType = @"Group";
	[self presentModalViewController:inputController animated:YES];
	[inputController release];
}

- (void)itemInputController:(itemInputController *)inputController didAddItem:(NSString	*)item highlight:(BOOL)highlight {
	if([item length] > 0){
		// Create a new instance of the entity managed by the fetched results controller.
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		
		NSArray *items = [self.fetchedResultsController fetchedObjects];
		
		// If appropriate, configure the new managed object.
		[newManagedObject setValue:item forKey:@"groupTitle"];
//		[newManagedObject setValue:[NSNumber numberWithInt:[[self.fetchedResultsController fetchedObjects] count]] forKey:@"displayOrder"];
		[newManagedObject setValue:[NSNumber numberWithInt:[items count]] forKey:@"displayOrder"];
		
//		NSLog(@"insert at count %i", [items count]);
		// Save the context.
		[UIAppDelegate saveContext:@"setupRootViewController didAddItem"];
	}
	[self dismissModalViewControllerAnimated:YES];
}
- (void)itemInputController:(itemInputController *)inputController didEditItem:(NSString *)oldTitle newTitle:(NSString *)newTitle oldHighlight:(BOOL)oldHighlight newHighlight:(BOOL)newHighlight {
	// NSLog(@"old:%@ new:%@", oldTitle, newTitle);
	
	NSManagedObject *group = [self timerGroupWithTitle:oldTitle];
	[group setValue:newTitle forKey:@"groupTitle"];
	[UIAppDelegate saveContext:@"didEditItem group"];
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return [UIAppDelegate.timersViewController.runningTimers count] == 0;
//	return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should be re-orderable.
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	changeIsUserDriven = YES;
	
	NSMutableArray *items = [[self.fetchedResultsController fetchedObjects] mutableCopy];
	
	// Grab the item we're moving.
	NSManagedObject *item = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
	
	// Remove the object we're moving from the array.
	[items removeObject:item];
	// Now re-insert it at the destination.
	[items insertObject:item atIndex:[destinationIndexPath row]];
	
	// All of the objects are now in their correct order. Update each
	// object's groupOrder field by iterating through the array.
	int i = 0;
	for (NSManagedObject *managedObject in items)
	{
		[managedObject setValue:[NSNumber numberWithInt:i] forKey:@"displayOrder"];
		// NSLog(@"Updated %@ to %i", managedObject, i);
		i++;
	}	

	// Save the context.
	[UIAppDelegate saveContext:@"setupRootViewController moveRowAtIndexPath"];
	
	[items release], items = nil;
	
	changeIsUserDriven = NO;

}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (tableView.editing) {
		NSManagedObject *group = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		inputController = [[itemInputController alloc] init];
		inputController.delegate = self;
		inputController.modalPresentationStyle = UIModalPresentationFormSheet;
		inputController.inputType = @"Group";
		inputController.oldTitle = [group valueForKey:@"groupTitle"];
		inputController.editMode = YES;
		[self presentModalViewController:inputController animated:YES];
		[inputController release];
	}else {
		// setup right pane
		setupDetailViewController *detailViewController = [[setupDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *setupDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
		setupDetailNavigationController.toolbarHidden = NO;
		
		// passing in group, core data
		NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		detailViewController.timerGroup = selectedObject;
		detailViewController.managedObjectContext = self.managedObjectContext;
		
		UISplitViewController *split = (UISplitViewController *)self.navigationController.parentViewController;
		split.viewControllers = [[[NSArray alloc] initWithObjects:[split.viewControllers objectAtIndex:0], setupDetailNavigationController, nil] autorelease];
		
		[detailViewController release];
		[setupDetailNavigationController release];
	
	}
}
/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
 */


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimerGroup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	if(!changeIsUserDriven){
		[self.tableView beginUpdates];
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
	if(!changeIsUserDriven){
		// NSLog(@"didChangeSection");
		switch(type) {
			case NSFetchedResultsChangeInsert:
				[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				break;
				
			case NSFetchedResultsChangeDelete:
				[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				break;
		}
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
	if(!changeIsUserDriven){
		// NSLog(@"didChangeObject");
		UITableView *tableView = self.tableView;
		
		switch(type) {
				
			case NSFetchedResultsChangeInsert:
				[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
				break;
				
			case NSFetchedResultsChangeDelete:
				[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				break;
				
			case NSFetchedResultsChangeUpdate:
				[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
				break;
				
			case NSFetchedResultsChangeMove:
				[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
				break;
		}
	}

}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if(!changeIsUserDriven){
//		NSLog(@"controllerDidChangeContent");
		
		[self.tableView endUpdates];
	}
	self.navigationItem.title = [NSString stringWithFormat:@"Groups (%d)", [[self.fetchedResultsController fetchedObjects] count]];
	NSLog(@"timers changed");
	[UIAppDelegate.timersViewController setTimersChanged:YES];
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
    [super dealloc];
}


@end

