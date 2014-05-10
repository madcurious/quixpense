//
//  UIView+SPR.m
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "UIView+SPR.h"

@implementation UIView (SPR)

- (void)sizeToFitWidth:(CGFloat)width
{
    CGSize labelSize = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, labelSize.height);
}

- (CGFloat)centerXInParent:(UIView *)parent
{
    CGFloat centerX = parent.frame.size.width / 2 - self.frame.size.width / 2;
    return centerX;
}

- (CGFloat)centerYInParent:(UIView *)parent
{
    CGFloat centerY = parent.frame.size.height / 2 - self.frame.size.height / 2;
    return centerY;
}

@end
