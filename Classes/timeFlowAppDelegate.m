//
//  timeFlowAppDelegate.m
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import "timeFlowAppDelegate.h"

@implementation timeFlowAppDelegate

@synthesize window, tabBarController, timersViewController, setupSplitController, logSplitController;

#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // tab bar controller 
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	
	// tabs
	timersViewController = [[timeFlowViewController alloc] init];
	timersViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Timers" image:[UIImage imageNamed:@"timer.png"] tag:0] autorelease];	
	
	setupSplitController = [[UISplitViewController alloc] init];
	setupSplitController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Setup" image:[UIImage imageNamed:@"gear.png"] tag:0] autorelease];	
	
	logSplitController = [[UISplitViewController alloc] init];
	logSplitController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Log" image:[UIImage imageNamed:@"log.png"] tag:0] autorelease];		
	
	// setup
	[setupSplitController setHidesMasterViewInPortrait:NO];
	[logSplitController setHidesMasterViewInPortrait:NO];

	// setup: left pane
	setupRootViewController *setupRootController = [[setupRootViewController alloc] initWithStyle:UITableViewStyleGrouped ];
	UINavigationController *setupNavigationController = [[UINavigationController alloc] initWithRootViewController:setupRootController];
	setupNavigationController.toolbarHidden = NO;

	// setup: right pane (blank)
	UIViewController *setupDetailController = [[UIViewController alloc] init];
	setupDetailController.view.backgroundColor = RGB(218,221,226);
	setupDetailController.view.opaque = YES;
	UINavigationController *setupNavigationDetailController = [[UINavigationController alloc] initWithRootViewController:setupDetailController];
	setupDetailController.navigationItem.title = @"Timers";
	
	// log: left pane
	LogViewController *logRootController = [[LogViewController alloc] init];
	UINavigationController *logNavigationController = [[UINavigationController alloc] initWithRootViewController:logRootController];
	logNavigationController.toolbarHidden = NO;
	
	// log: right pane (blank)
	UIViewController *logDetailController = [[UIViewController alloc] init];
	logDetailController.view.backgroundColor = [UIColor whiteColor];
	UINavigationController *logNavigationDetailController = [[UINavigationController alloc] initWithRootViewController:logDetailController];
	logDetailController.navigationItem.title = @"Event";	
	// core data
	timersViewController.managedObjectContext = self.managedObjectContext;
	setupRootController.managedObjectContext = self.managedObjectContext;
	logRootController.managedObjectContext = self.managedObjectContext;

	// add controllers to split view and tab bar
	tabBarController.viewControllers = [NSArray arrayWithObjects:timersViewController, setupSplitController, logSplitController, nil];
	setupSplitController.viewControllers = [NSArray arrayWithObjects:setupNavigationController, setupNavigationDetailController, nil];
	logSplitController.viewControllers = [NSArray arrayWithObjects:logNavigationController, logNavigationDetailController, nil];
	
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	[UIApplication sharedApplication].idleTimerDisabled = YES;

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[timersViewController.runningTimers count] ];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[UIApplication sharedApplication].idleTimerDisabled = YES;

}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[timersViewController.runningTimers count] ];

	NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            [UIAppDelegate errorWithTitle:@"managedObjectContext save error" message:[NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
        } 
    }
	
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)tappedViewController {
//	NSLog(@"tab %@", tappedViewController);
	if ([[timersViewController runningTimers] count] > 0 && tappedViewController == setupSplitController) {
		UIAlertView *timersAreRunning = [[UIAlertView alloc] initWithTitle:@"Timers running" message:@"Please stop all timers before setup" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[timersAreRunning show];
		return NO;
	}else {
		return YES;
	}

//	return tappedViewController != navigationController;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"coredataproject" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath]; 
	// NSLog(@"model path %@", modelPath);
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"coredataproject.sqlite"]];
    
    NSError *error = nil;
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        [UIAppDelegate errorWithTitle:@"Persistent store coordinator error" message:[NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
    }    
    
    return persistentStoreCoordinator_;
}
-(void) saveContext:(NSString *)triggeredBy {
	// Save the context.
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		[UIAppDelegate errorWithTitle:@"Save error" message:[NSString stringWithFormat:@"Unresolved %@ error %@, %@", triggeredBy, error, [error userInfo]]];
	}
}
-(void) errorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage{
	DLog(@"%@: %@", errorTitle, errorMessage);
	UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[errorAlert show];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {

    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
	
	[tabBarController release];
	[timersViewController release];
	[setupSplitController release];
	[logSplitController release];

    [window release];
    [super dealloc];
}


@end
