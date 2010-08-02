//
//  timeFlowAppDelegate.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright NUBIC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "timeFlowViewController.h"
#import "RootViewController.h"
#import "DetailViewController.h"

#define UIAppDelegate ((timeFlowAppDelegate *)[UIApplication sharedApplication].delegate)

//@class timeFlowViewController;

@interface timeFlowAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    timeFlowViewController *timersViewController;
	UITabBarController *tabBarController;
	UINavigationController *navigationController;
	UISplitViewController *setupSplitController;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet timeFlowViewController *timersViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UISplitViewController *setupSplitController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;


@end

