//
//  SPRExpense+Extension.m
//  Spare
//
//  Created by Matt Quiros on 4/5/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpense+Extension.h"

@implementation SPRExpense (Extension)

- (NSString *)amountAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return [formatter stringFromNumber:self.amount];
}

@end
