//
//  SPRField.m
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRField.h"

@implementation SPRField

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (id)initWithName:(NSString *)name value:(id)value
{
    if (self = [self initWithName:name]) {
        _value = value;
    }
    return self;
}

@end
