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
#import "setupRootViewController.h"
#import "setupDetailViewController.h"
#import "LogViewController.h"
#import "UISplitViewController+Rotate.h"

//@class timeFlowViewController;

@interface timeFlowAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
    timeFlowViewController *timersViewController;
	UISplitViewController *setupSplitController;
	UISplitViewController *logSplitController;	

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) timeFlowViewController *timersViewController;
@property (nonatomic, retain) UISplitViewController *setupSplitController;
@property (nonatomic, retain) UISplitViewController *logSplitController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void) saveContext:(NSString *)triggeredBy;
-(void) errorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage;
- (NSString *)applicationDocumentsDirectory;
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;


@end

