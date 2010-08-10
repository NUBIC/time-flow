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
	UILabel *highlightLabel;
	UISwitch *highlightSwitch;
	UINavigationItem *navItem;
	id<itemInputControllerDelegate> delegate;
	NSString *inputType;
	Boolean editMode;
	NSString *oldTitle;
	Boolean oldHighlightOn;
}


@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *highlightLabel;
@property (nonatomic, retain) IBOutlet UISwitch *highlightSwitch;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) NSString *inputType;
@property (nonatomic, assign) Boolean editMode;
@property (nonatomic, retain) NSString *oldTitle;
@property (nonatomic, assign) Boolean oldHighlightOn;

@property (assign) id<itemInputControllerDelegate> delegate;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@protocol itemInputControllerDelegate <NSObject>

- (void)itemInputController:(itemInputController *)inputController didAddItem:(NSString	*)item highlight:(BOOL)highlight;
- (void)itemInputController:(itemInputController *)inputController didEditItem:(NSString *)oldTitle newTitle:(NSString *)newTitle oldHighlight:(BOOL)oldHighlight newHighlight:(BOOL)newHighlight;

@end
