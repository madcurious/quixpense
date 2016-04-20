//
//  NSDate+SPR.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants
#import "SPRTimeFrame.h"

@interface NSDate (SPR)

- (BOOL)isSameDayAsDate:(NSDate *)date;
- (NSString *)textInForm;

- (NSDate *)firstMomentInTimeFrame:(SPRTimeFrame)timeFrame;
- (NSDate *)lastMomentInTimeFrame:(SPRTimeFrame)timeFrame;

+ (NSDate *)simplifiedDate;
+ (NSDate *)simplifiedDateFromDate:(NSDate *)date;

@end
