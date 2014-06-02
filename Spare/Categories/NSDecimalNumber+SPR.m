//
//  NSDecimalNumber+SPR.m
//  Spare
//
//  Created by Matt Quiros on 4/15/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSDecimalNumber+SPR.h"

@implementation NSDecimalNumber (SPR)

- (NSString *)currencyString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSString *currencyString = [formatter stringFromNumber:self];
    return currencyString;
}

+ (instancetype)decimalNumberWithNumber:(NSNumber *)number
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithDecimal:[number decimalValue]];
    return decimalNumber;
}

@end
