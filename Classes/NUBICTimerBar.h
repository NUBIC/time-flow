//
//  NUBICTimerBar.h
//  timeFlow
//
//  Created by Mark Yoon on 7/29/2010.
//  Copyright 2010 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NUBICTimerBar : UIView {

}
- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
- (void) setItems:(NSArray *)buttons animated:(Boolean)animated;

@end
