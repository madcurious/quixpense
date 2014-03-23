//
//  SPRCategory.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategory.h"

// Categories
#import "UIColor+HexColor.h"

@implementation SPRCategory

- (id)initWithName:(NSString *)name colorNumber:(NSNumber *)colorNumber
{
    if (self = [super init]) {
        _name = name;
        _colorNumber = colorNumber;
    }
    return self;
}

+ (NSArray *)dummies
{
    return @[[[SPRCategory alloc] initWithName:@"Food and Drinks" colorNumber:@1],
             [[SPRCategory alloc] initWithName:@"Transportation" colorNumber:@20],
             [[SPRCategory alloc] initWithName:@"Health and Medical Expenses" colorNumber:@25],
             [[SPRCategory alloc] initWithName:@"Phone Bills" colorNumber:@14],
             [[SPRCategory alloc] initWithName:@"Miscellaneous Expenses" colorNumber:@35],
             [[SPRCategory alloc] initWithName:@"Blow-outs" colorNumber:@28]];
}

+ (NSArray *)colors
{
    return @[// Canary
             [UIColor colorFromHex:0xFCF0AD],
             
             // Neon
             [UIColor colorFromHex:0xE9E74A],
             [UIColor colorFromHex:0xEE5E9F],
             [UIColor colorFromHex:0xFFDD2A],
             [UIColor colorFromHex:0xF59DB9],
             [UIColor colorFromHex:0xF9A55B],
             
             // Ultra
             [UIColor colorFromHex:0xD0E17D],
             [UIColor colorFromHex:0x36A9CE],
             [UIColor colorFromHex:0xEF5AA1],
             [UIColor colorFromHex:0xAE86BC],
             [UIColor colorFromHex:0xFFDF25],
             
             // Tropical
             [UIColor colorFromHex:0x56C4E8],
             [UIColor colorFromHex:0xD0E068],
             [UIColor colorFromHex:0xCD9EC0],
             [UIColor colorFromHex:0xED839D],
             [UIColor colorFromHex:0xFFE476],
             
             // Samba
             [UIColor colorFromHex:0xCDDD73],
             [UIColor colorFromHex:0xF35F6D],
             [UIColor colorFromHex:0xFAA457],
             [UIColor colorFromHex:0x35BEB7],
             [UIColor colorFromHex:0xD189B9],
             
             // Aquatic
             [UIColor colorFromHex:0x99C7BC],
             [UIColor colorFromHex:0x89B18C],
             [UIColor colorFromHex:0x738FA7],
             [UIColor colorFromHex:0x8A8FA3],
             [UIColor colorFromHex:0x82ACB8],
             
             // Sunbrite
             [UIColor colorFromHex:0xF9D6AC],
             [UIColor colorFromHex:0xE9B561],
             [UIColor colorFromHex:0xE89132],
             [UIColor colorFromHex:0xDA7527],
             [UIColor colorFromHex:0xDEAC2F],
             
             // Classic
             [UIColor colorFromHex:0xBAB7A9],
             [UIColor colorFromHex:0xBFB4AF],
             [UIColor colorFromHex:0xCDC4C1],
             [UIColor colorFromHex:0xCFB69E],
             [UIColor colorFromHex:0xD0AD87]];
}

@end