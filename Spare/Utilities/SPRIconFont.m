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

+ (NSAttributedString *)iconForEdit
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForEdit] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:20]}];
    return attributedString;
}

+ (NSAttributedString *)iconForNewCategory
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewCategory] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:22]}];
    return attributedString;
}

+ (NSAttributedString *)iconForNewExpense
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewExpense] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:30]}];
    return attributedString;
}

#pragma mark - Character mappings

+ (NSString *)stringForArchive
{
    return @"f";
}

+ (NSString *)stringForDelete
{
    return @"c";
}

+ (NSString *)stringForEdit
{
    return @"b";
}

+ (NSString *)stringForNewCategory
{
    return @"d";
}

+ (NSString *)stringForNewExpense
{
    return @"e";
}

+ (NSString *)stringForSettings
{
    return @"a";
}

@end
