//
//  SPRExpense.m
//  Spare
//
//  Created by Matt Quiros on 4/13/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpense.h"
#import "SPRCategory.h"


@implementation SPRExpense

@dynamic amount;
@dynamic dateSpent;
@dynamic name;
@dynamic dateSpentAsSectionTitle;
@dynamic category;

- (NSString *)dateSpentAsSectionTitle
{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:self.dateSpent];
//    NSString *sectionInfo = [NSString stringWithFormat:@"%d", components.month, components.day, components.year];
    
    NSString *sectionInfo = [NSString stringWithFormat:@"%f", self.dateSpent.timeIntervalSince1970];
    
    return sectionInfo;
}

@end
