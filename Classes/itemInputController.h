//
//  itemInputController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/27/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol itemInputControllerDelegate;

@interface itemInputController : UIViewController {
	UITextField *textField;
	UINavigationItem *navItem;
	id<itemInputControllerDelegate> delegate;
	NSString *inputType;
}


@property (retain) IBOutlet UITextField *textField;
@property (retain) IBOutlet UINavigationItem *navItem;
@property (assign) id<itemInputControllerDelegate> delegate;
@property (retain) NSString *inputType;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@protocol itemInputControllerDelegate <NSObject>

- (void)itemInputController:(itemInputController *)inputController didAddItem:(NSString	*)item;

@end
