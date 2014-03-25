//
//  UIView+SubviewFinder.h
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SubviewFinder)

// This method does exactly the same thing as Tom Parry's huntedSubviewWithClassName:
// in http://b2cloud.com.au/tutorial/reordering-a-uitableviewcell-from-any-touch-point/
// which looks for an (anonymous) subview whose class is the given class name.
- (UIView *)subviewWithClassName:(NSString *)className;

@end
