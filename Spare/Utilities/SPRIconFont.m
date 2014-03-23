//
//  SPRIconFont.m
//  Spare
//
//  Created by Matt Quiros on 3/23/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRIconFont.h"

static NSString * const kFontName = @"spare-icons";

@implementation SPRIconFont

+ (NSAttributedString *)iconForNewCategory
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewCategory] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:20]}];
    return attributedString;
}

+ (NSAttributedString *)iconForNewExpense
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewExpense] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:20]}];
    return attributedString;
}

#pragma mark - Character mappings

+ (NSString *)stringForNewExpense
{
    return @"1";
}

+ (NSString *)stringForNewCategory
{
    return @"2";
}

+ (NSString *)stringForSettings
{
    return @"3";
}

+ (NSString *)stringForArchive
{
    return @"4";
}

+ (NSString *)stringForDollarSign
{
    return @"5";
}

@end
