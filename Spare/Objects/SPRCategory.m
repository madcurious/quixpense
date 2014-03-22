//
//  SPRCategory.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategory.h"

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
             [[SPRCategory alloc] initWithName:@"Transportation" colorNumber:@2],
             [[SPRCategory alloc] initWithName:@"Health and Medical Expenses" colorNumber:@3],
             [[SPRCategory alloc] initWithName:@"Phone Bills" colorNumber:@4],
             [[SPRCategory alloc] initWithName:@"Miscellaneous Expenses" colorNumber:@5],
             [[SPRCategory alloc] initWithName:@"Blow-outs" colorNumber:@6]];
}

@end