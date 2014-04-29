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

- (NSDate *)firstMomentInTimeFrame:(SPRTimeFrame)timeFrame
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    NSDate *firstMoment = nil;
    
    NSUInteger commonComponents = NSYearCalendarUnit|NSMonthCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    
    switch (timeFrame) {
        case SPRTimeFrameDay: {
            components = [calendar components:commonComponents fromDate:self];
            break;
        }
        case SPRTimeFrameWeek: {
            components = [calendar components:commonComponents|NSYearForWeekOfYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self];
            components.weekday = 1;
            break;
        }
        case SPRTimeFrameMonth: {
            components = [calendar components:commonComponents|NSDayCalendarUnit fromDate:self];
            components.day = 1;
            break;
        }
        case SPRTimeFrameYear: {
            components = [calendar components:commonComponents|NSDayCalendarUnit fromDate:self];
            components.month = 1;
            components.day = 1;
            break;
        }
        default:
            break;
    }
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    firstMoment = [calendar dateFromComponents:components];
    return firstMoment;
}

- (NSDate *)lastMomentInTimeFrame:(SPRTimeFrame)timeFrame
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    NSDate *lastMoment = nil;
    
    NSUInteger commonComponents = NSYearCalendarUnit|NSMonthCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    
    switch (timeFrame) {
        case SPRTimeFrameDay: {
            components = [calendar components:commonComponents fromDate:self];
            break;
        }
        case SPRTimeFrameWeek: {
            components = [calendar components:commonComponents|NSYearForWeekOfYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self];
            components.weekday = 7;
            break;
        }
        case SPRTimeFrameMonth: {
            // Get the number of days in this date's month.
            NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
            
            components = [calendar components:commonComponents|NSDayCalendarUnit fromDate:self];
            components.day = days.length;
            break;
        }
        case SPRTimeFrameYear: {
            components = [calendar components:commonComponents|NSDayCalendarUnit fromDate:self];
            components.month = 12;
            components.day = 31;
            break;
        }
        default:
            return nil;
    }
    
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    lastMoment = [calendar dateFromComponents:components];
    
    return lastMoment;
}

+ (NSDate *)simplifiedDate
{
    return [self simplifiedDateFromDate:[NSDate date]];
}

+ (NSDate *)simplifiedDateFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *significantComponents = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:date];
    significantComponents.calendar = calendar;
    NSDate *simplifiedDate = [calendar dateFromComponents:significantComponents];
    return simplifiedDate;
}

@end
