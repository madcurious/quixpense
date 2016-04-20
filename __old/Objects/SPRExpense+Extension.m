//
//  SPRExpense+Extension.m
//  Spare
//
//  Created by Matt Quiros on 4/5/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpense+Extension.h"

@implementation SPRExpense (Extension)

- (NSString *)dateSpentAsSectionTitle
{
    NSString *sectionInfo = [NSString stringWithFormat:@"%f", self.dateSpent.timeIntervalSince1970];
    return sectionInfo;
}

@end
