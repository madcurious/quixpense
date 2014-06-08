//
//  SPRExpenseSectionHeader.m
//  Spare
//
//  Created by Matt Quiros on 6/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseSectionHeader.h"

@implementation SPRExpenseSectionHeader

- (instancetype)initWithDate:(NSDate *)date
{
    if (self = [super init]) {
        _date = date;
    }
    return self;
}

@end
