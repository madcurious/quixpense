//
//  UILabel+SPR.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "UILabel+SPR.h"

@implementation UILabel (SPR)

- (void)sizeToFitWidth:(CGFloat)width
{
    CGSize labelSize = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, labelSize.height);
}

@end