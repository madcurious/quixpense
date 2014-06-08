//
//  SPRNSIndexPathTransformer.m
//  Spare
//
//  Created by Matt Quiros on 6/8/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRNSIndexPathTransformer.h"

@implementation SPRNSIndexPathTransformer

+ (Class)transformedValueClass
{
    return [NSIndexPath class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

@end
