//
//  UIView+SubviewFinder.m
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "UIView+SubviewFinder.h"

@implementation UIView (SubviewFinder)

- (UIView *)subviewWithClassName:(NSString *)className
{
    if ([[[self class] description] isEqualToString:className]) {
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        UIView *matchingSubview = [subview subviewWithClassName:className];
        if (matchingSubview != nil) {
            return matchingSubview;
        }
    }
    
    return nil;
}

@end
