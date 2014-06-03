//
//  SPRExpenseSectionHeader.m
//  Spare
//
//  Created by Matt Quiros on 6/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseSection.h"

@implementation SPRExpenseSection

- (instancetype)initWithDate:(NSDate *)date
{
    if (self = [super init]) {
        _date = date;
    }
    return self;
}

@end
