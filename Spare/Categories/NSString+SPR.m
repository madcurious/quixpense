//
//  NSString+SPR.m
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSString+SPR.h"

@implementation NSString (SPR)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)containsCharacterFromCharacterSet:(NSCharacterSet *)characterSet
{
    NSRange range = [self rangeOfCharacterFromSet:characterSet];
    return range.location != NSNotFound;
}

@end
