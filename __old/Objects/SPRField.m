//
//  SPRField.m
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRField.h"

@implementation SPRField

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name value:(id)value
{
    if (self = [self initWithName:name]) {
        _value = value;
    }
    return self;
}

- (instancetype)initWithValue:(id)value
{
    if (self = [self initWithName:nil]) {
        _value = value;
    }
    return self;
}

@end
