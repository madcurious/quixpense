//
//  NSIndexPath+SPR.m
//  Spare
//
//  Created by Matt Quiros on 6/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSIndexPath+SPR.h"

@implementation NSIndexPath (SPR)

- (NSIndexPath *)indexPathByOffsettingRow:(NSInteger)offset
{
    return [NSIndexPath indexPathForRow:(self.row + offset) inSection:self.section];
}

- (NSIndexPath *)indexPathByOffsettingSection:(NSInteger)offset
{
    return [NSIndexPath indexPathForRow:self.row inSection:(self.section + offset)];
}

@end
