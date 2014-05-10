//
//  UIView+SPR.h
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SPR)

- (void)sizeToFitWidth:(CGFloat)width;
- (CGFloat)centerXInParent:(UIView *)parent;
- (CGFloat)centerYInParent:(UIView *)parent;

@end
