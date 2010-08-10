//
//  DetailViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 7/28/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "setupDetailViewController.h"


@implementation setupDetailViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_, timerGroup;

#pragma mark -
#pragma mark Constants


#define _highlightColor	0xBB1100

#pragma mark -
#pragma mark Core Data

- (NSManagedObject *)timerWithTitle:(NSString *)timerTitle{
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"timerWithTitle" substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:timerTitle, @"timerTitle", self.timerGroup, @"timerGroup", nil]];

	// execute fetch request
	NSArray *timers = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!timers || [timers count] != 1) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		[UIAppDelegate errorWithTitle:@"Fetch error" message:[NSString stringWithFormat:@"setupDetailViewController timerWithTitle fetch error %@, %@", error, [error userInfo]]];
	}
	return [timers lastObject];
}
- (BOOL)timerIsUnique:(NSString *)timerTitle {
	NSError *error = nil;
	NSFetchRequest *fetch = [[[self.managedObjectContext persistentStoreCoordinator] managedObjectModel] fetchRequestFromTemplateWithName:@"timerWithTitle" substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:timerTitle, @"timerTitle", self.timerGroup, @"timerGroup", nil]];

	// execute fetch request
	NSArray *timers = [self.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!timers) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		[UIAppDelegate errorWithTitle:@"Fetch error" message:[NSString stringWithFormat:@"setupDetailViewController timerIsUnique fetch error %@, %@", error, [error userInfo]]];
	}
	return [timers count] == 0;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelectionDuringEditing = YES;
	self.tableView.allowsSelection = NO;
	
    // Set up the edit and add buttons.
	[self setToolbarItems:[NSArray arrayWithObject:self.editButtonItem]];    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;

	if(self.timerGroup){
		self.navigationItem.title = [NSString stringWithFormat:@"Timers (%d)", [[self.fetchedResultsController fetchedObjects] count]];
	}
    [addButton release];
}


/*
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
//  NSLog(@"configureCell atIndexPath %@", indexPath);
//	NSLog(@"results %@", [self.fetchedResultsController fetchedObjects]);
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"timerTitle"] description];
}

#pragma mark -
#pragma mark itemInputControllerDelegate

- (void)insertNewObject {
	inputController = [[itemInputController alloc] init];
	inputController.delegate = self;
	inputController.modalPresentationStyle = UIModalPresentationFormSheet;
	inputController.inputType = @"Timer";
	[self presentModalViewController:inputController animated:YES];
	[inputController release];
}


- (void)itemInputController:(itemInputController *)inputController didAddItem:(NSString	*)item highlight:(BOOL)highlight{
	// NSLog(@"itemInputController didAddItem:%@ highlight:%d", item, highlight);
	if([item length] > 0){
		if ([self timerIsUnique:item]) {
			// Create a new instance of the entity managed by the fetched results controller.
			NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
			NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
			NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
			
			NSArray *items = [self.fetchedResultsController fetchedObjects];
			
			// If appropriate, configure the new managed object.
			[newManagedObject setValue:item forKey:@"timerTitle"];
			//		[newManagedObject setValue:[NSNumber numberWithInt:[[self.fetchedResultsController fetchedObjects] count]] forKey:@"displayOrder"];
			[newManagedObject setValue:[NSNumber numberWithInt:[items count]] forKey:@"displayOrder"];
			[newManagedObject setValue:self.timerGroup forKey:@"timerGroup"];
			if (highlight) {
				[newManagedObject setValue:HEX(_highlightColor,0.8) forKey:@"borderColor"];
			}
			
			//		NSLog(@"inserted %@", newManagedObject);
			//		NSLog(@"insert at %i", [items count]);
			// Save the context.
			[UIAppDelegate saveContext:@"setupDetailViewController didAddItem"];
			[self dismissModalViewControllerAnimated:YES];
		}else {
			UIAlertView *notUnique = [[UIAlertView alloc] initWithTitle:@"Timer Not Unique" message:@"The title you selected is already taken." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[notUnique show];
			[notUnique release];
		}
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}	
}
- (void)itemInputController:(itemInputController *)inputController didEditItem:(NSString *)oldTitle newTitle:(NSString *)newTitle oldHighlight:(BOOL)oldHighlight newHighlight:(BOOL)newHighlight {
//	NSLog(@"itemInputController didEditItem:%@ newTitle:%@ oldHighlight:%d highlight:%d", oldTitle, newTitle, oldHighlight, newHighlight);
	if (![oldTitle isEqualToString:newTitle] && ![self timerIsUnique:newTitle]) {
		DLog(@"different title, not unique");
		UIAlertView *notUnique = [[UIAlertView alloc] initWithTitle:@"Timer Not Unique" message:@"The title you selected is already taken." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[notUnique show];
		[notUnique release];
	}else if (![oldTitle isEqualToString:newTitle] || oldHighlight != newHighlight) {
		NSManagedObject *timer = [self timerWithTitle:oldTitle];
		[timer setValue:newTitle forKey:@"timerTitle"];
		[timer setValue:newHighlight ? HEX(_highlightColor,0.8) : nil forKey:@"borderColor"];
		[UIAppDelegate saveContext:@"didEditItem timer"];
		[self dismissModalViewControllerAnimated:YES];
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}
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



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
		// Save the context.
		[UIAppDelegate saveContext:@"setupDetailViewController commitEditingStyle"];
    }   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should be re-orderable.
    return YES;
}

// Override to support rearranging the table view.
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
	[UIAppDelegate saveContext:@"setupDetailViewController moveRowAtIndexPath"];
	
	[items release], items = nil;
	
	changeIsUserDriven = NO;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing) {
		NSManagedObject *timer = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		inputController = [[itemInputController alloc] init];
		inputController.delegate = self;
		inputController.modalPresentationStyle = UIModalPresentationFormSheet;
		inputController.inputType = @"Timer";
		inputController.oldTitle = [timer valueForKey:@"timerTitle"];
		inputController.oldHighlightOn = [timer valueForKey:@"borderColor"] != nil;
		inputController.editMode = YES;
		[self presentModalViewController:inputController animated:YES];
		[inputController release];
	}else {

	}
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
//	NSLog(@"fetchedResultsController");
//	NSLog(@"timerGroup %@", self.timerGroup);

    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Timer" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
	// http://iphoneincubator.com/blog/data-management/delete-the-nsfetchedresultscontroller-cache-before-changing-the-nspredicate/comment-page-1
	[NSFetchedResultsController deleteCacheWithName:nil];  
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timerGroup == %@", self.timerGroup];
	[fetchRequest setPredicate:predicate];
	
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
    
//	NSLog(@"fetchRequest %@", fetchRequest);
	
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved setupDetailViewController fetchedResultsController error %@, %@", error, [error userInfo]);
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
//		NSLog(@"didChangeSection");
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
//		NSLog(@"didChangeObject");
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
				self.navigationItem.title = [NSString stringWithFormat:@"Timers (%d)", [[self.fetchedResultsController fetchedObjects] count]];
		[self.tableView endUpdates];
		
	}
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
	
	[timerGroup release];
	
    [super dealloc];
}


@end

