//
//  SPRIconFont.h
//  Spare
//
//  Created by Matt Quiros on 3/23/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRIconFont : NSObject

+ (NSAttributedString *)editIcon;

+ (NSAttributedString *)addCategoryIcon;
+ (NSAttributedString *)addCategoryIconDisabled;

+ (NSAttributedString *)addExpenseIcon;
+ (NSAttributedString *)addExpenseIconDisabled;

@end
