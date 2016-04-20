//
//  NSFetchedResultsController+SPR.m
//  Spare
//
//  Created by Matt Quiros on 6/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "NSFetchedResultsController+SPR.h"

@implementation NSFetchedResultsController (SPR)

- (NSUInteger)lastIndexInSection:(NSUInteger)section
{
    NSUInteger numberOfObjects = [self numberOfObjectsInSection:section];
    return (numberOfObjects - 1);
}

- (id)lastObjectInSection:(NSUInteger)section
{
    NSUInteger row = [self lastIndexInSection:section];
    if (row == -1) {
        return nil;
    }
    return [self objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = self.sections[section];
    NSUInteger numberOfObjects = [theSection numberOfObjects];
    return numberOfObjects;
}

@end
