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

+ (NSAttributedString *)addCategoryIcon
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewCategory] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:22]}];
    return attributedString;
}

+ (NSAttributedString *)addCategoryIconDisabled
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewCategory] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:22], NSForegroundColorAttributeName : [UIColor grayColor]}];
    return attributedString;
}

+ (NSAttributedString *)addExpenseIcon
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewExpense] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:30]}];
    return attributedString;
}

+ (NSAttributedString *)addExpenseIconDisabled
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForNewExpense] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:30], NSForegroundColorAttributeName : [UIColor grayColor]}];
    return attributedString;
}

+ (NSAttributedString *)deleteIcon
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForDelete] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:18]}];
    return attributedString;
}

+ (NSAttributedString *)moveIcon
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForMove] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:20]}];
    return attributedString;
}

+ (NSAttributedString *)editIcon
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[SPRIconFont stringForEdit] attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontName size:20]}];
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

+ (NSString *)stringForMove
{
    return @"g";
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
