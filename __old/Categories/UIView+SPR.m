//
//  UIView+SPR.m
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "UIView+SPR.h"

@implementation UIView (SPR)

- (CGFloat)centerXInParent:(UIView *)parent
{
    CGFloat centerX = parent.frame.size.width / 2 - self.intrinsicContentSize.width / 2;
    return centerX;
}

- (CGFloat)centerYInParent:(UIView *)parent
{
    CGFloat centerY = parent.frame.size.height / 2 - self.intrinsicContentSize.height / 2;
    return centerY;
}

- (void)sizeToFitWidth:(CGFloat)width
{
    CGSize size = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, size.height);
}

@end
