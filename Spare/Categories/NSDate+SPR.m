//
//  NSDate+SPR.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSDate+SPR.h"

@implementation NSDate (SPR)

- (BOOL)isSameDayAsDate:(NSDate *)date
{
    unsigned componentFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *ownComponents = [calendar components:componentFlags fromDate:self];
    NSDateComponents *dateComponents = [calendar components:componentFlags fromDate:date];
    
    return ownComponents.month == dateComponents.month &&
    ownComponents.day == dateComponents.day &&
    ownComponents.year == dateComponents.year;
}

- (NSString *)textInForm
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *text;
    
    if ([[NSDate date] isSameDayAsDate:self]) {
        formatter.dateStyle = NSDateFormatterLongStyle;
        text = [NSString stringWithFormat:@"Today, %@", [formatter stringFromDate:self]];
    } else {
        formatter.dateStyle = NSDateFormatterFullStyle;
        text = [formatter stringFromDate:self];
    }
    
    return text;
}

+ (NSDate *)simplifyToDayComponent:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    NSDate *simplifiedDate = [calendar dateFromComponents:components];
    return simplifiedDate;
}

@end
