//
//  NSNumber+SPR.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSNumber+SPR.h"

@implementation NSNumber (SPR)

- (NSString *)currencyString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSString *currencyString = [formatter stringFromNumber:self];
    return currencyString;
}

@end
