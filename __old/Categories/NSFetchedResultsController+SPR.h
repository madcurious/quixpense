//
//  NSFetchedResultsController+SPR.h
//  Spare
//
//  Created by Matt Quiros on 6/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (SPR)

- (NSUInteger)lastIndexInSection:(NSUInteger)section;
- (id)lastObjectInSection:(NSUInteger)section;

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section;

@end
