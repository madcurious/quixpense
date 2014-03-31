//
//  SPRCategory+Extension.h
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategory.h"

@interface SPRCategory (Extension)

+ (NSArray *)allCategories;
+ (void)enumerateAllCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completionBlock;
+ (NSArray *)colors;

@end
