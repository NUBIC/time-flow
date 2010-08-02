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


@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) NSString *inputType;

@property (assign) id<itemInputControllerDelegate> delegate;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@protocol itemInputControllerDelegate <NSObject>

- (void)itemInputController:(itemInputController *)inputController didAddItem:(NSString	*)item;

@end
