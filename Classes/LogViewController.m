//
//  LogViewController.m
//  timeFlow
//
//  Created by Mark Yoon on 8/2/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import "LogViewController.h"

@implementation LogViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Set up the edit and add buttons.
    
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayComposerSheet)] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil] autorelease];
	self.navigationItem.title = [NSString stringWithFormat:@"Events (%d)", [[self.fetchedResultsController fetchedObjects] count]];
	if (!MFMailComposeViewController.canSendMail) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Mail

-(NSData *)timersToCSV{
	
	NSDateFormatter *ldf = [[NSDateFormatter alloc] init];
	[ldf setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"]; 
	
	NSDateFormatter *stf = [[NSDateFormatter alloc] init];
	[stf setDateFormat:@"H:mm:ss"];

	NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
	[sdf setDateFormat:@"yyyy-MM-dd"];

	NSManagedObject *event;
	NSMutableString *csv = [[[NSMutableString alloc] init] autorelease];
	[csv appendString:@"Group,Timer,Started On (Date),Started On (Time),Ended On (Date), Ended On Time,Duration\r\n"];
	
	for (event in [self.fetchedResultsController fetchedObjects]) {
		
		
		[csv appendFormat:@"%@,%@,%@,%@,", \
		 [[event valueForKey:@"groupTitle"] description], \
		 [[event valueForKey:@"timerTitle"] description], \
		 [sdf stringFromDate:[ldf dateFromString:[[event valueForKey:@"startedOn"] description]]], \
		 [stf stringFromDate:[ldf dateFromString:[[event valueForKey:@"startedOn"] description]]]];
		
		if([event valueForKey:@"endedOn"]){
			[csv appendFormat:@"%@,%@,%@\r\n", \
			 [sdf stringFromDate:[ldf dateFromString:[[event valueForKey:@"endedOn"] description]]], \
			 [stf stringFromDate:[ldf dateFromString:[[event valueForKey:@"endedOn"] description]]], \
			 [NSString stringWithFormat:@"%i", (int)[[ldf dateFromString:[[event valueForKey:@"endedOn"] description]] timeIntervalSinceDate:[ldf dateFromString:[[event valueForKey:@"startedOn"] description]]]]
			];
		}else {
			[csv appendString:@",,\r\n"];
		}
	}
	
	[ldf release];
	[stf release];
	[sdf release];
	return [csv dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)displayComposerSheet{
	if (MFMailComposeViewController.canSendMail) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
				
		// Subject
		[picker setSubject:@"timeFlow log"];
		
		// Recipients
		//    NSArray *toRecipients = [NSArray arrayWithObjects:@"first@example.com", nil];
		//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
		//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com", nil];
		//    [picker setToRecipients:toRecipients];
		//    [picker setCcRecipients:ccRecipients];
		//    [picker setBccRecipients:bccRecipients];
		
		// Attachment
		NSDateFormatter *shortDateTimeFormat = [[NSDateFormatter alloc] init];
		[shortDateTimeFormat setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
		[picker addAttachmentData:[self timersToCSV]
				mimeType:@"text/csv"
				fileName:[NSString stringWithFormat:@"timeFlow_%@.csv", [shortDateTimeFormat stringFromDate:[NSDate date]]]]; 
		
		// Body
		// NSString *emailBody = @"";
		// [picker setMessageBody:emailBody isHTML:NO];
		
		// Present the mail composition modally
		//	picker.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController:picker animated:YES];
		[picker release]; // Can safely release the controller now.
		
	}else {
		UIAlertView *mailDisabled = [[UIAlertView alloc] initWithTitle:@"Cannot send email" message:@"Please set up this device for the delivery of email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[mailDisabled show];
	}


}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:13.0];
		cell.textLabel.textColor = [UIColor grayColor];
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18.0];
		cell.detailTextLabel.textColor = [UIColor blackColor];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	//  NSLog(@"configureCell atIndexPath %@", indexPath);
	//	NSLog(@"results %@", [self.fetchedResultsController fetchedObjects]);
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"groupTitle"] description];
	cell.detailTextLabel.text = [[managedObject valueForKey:@"timerTitle"] description];
	
	UILabel *startLabel = [[UILabel alloc] init];
	startLabel.font = [UIFont systemFontOfSize:13.0];
	startLabel.textColor = [UIColor lightGrayColor];
	startLabel.backgroundColor = [UIColor clearColor];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"]; 
	// http://blog.evandavey.com/2008/12/how-to-convert-a-string-to-nsdate.html
	// http://unicode.org/reports/tr35/#Date_Format_Patterns
	
	NSDateFormatter *shortTimeFormat = [[NSDateFormatter alloc] init];
	[shortTimeFormat setDateFormat:@"H:mm:ss"];
	
	NSDate *sOn = [df dateFromString:[[managedObject valueForKey:@"startedOn"] description]];
	if([managedObject valueForKey:@"endedOn"]){
		NSDate *eOn = [df dateFromString:[[managedObject valueForKey:@"endedOn"] description]];		
		startLabel.text = [NSString stringWithFormat:@"%is", (int)[eOn timeIntervalSinceDate:sOn]];
	}else {
		startLabel.text = [NSString stringWithFormat:@"started: %@", [shortTimeFormat stringFromDate:sOn]];
	}
	
	cell.accessoryView = startLabel;
	[startLabel sizeToFit];
	
	[df release];
	[shortTimeFormat release];
	[startLabel release];
	
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startedOn" ascending:NO];
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
		NSLog(@"didChangeSection");
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
    [super dealloc];
}


@end

