//
//  timeFlowViewController.h
//  timeFlow
//
//  Created by Mark Yoon on 7/13/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeFlowViewController : UIViewController {

	UILabel *logbox;
	UIImage *offImage;
	UIImage *onImage;
}

-(IBAction) pushed:(id)sender;

@property (assign) IBOutlet UILabel *logbox;

@end

