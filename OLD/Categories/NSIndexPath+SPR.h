//
//  NSIndexPath+SPR.h
//  Spare
//
//  Created by Matt Quiros on 6/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (SPR)

- (NSIndexPath *)indexPathByOffsettingRow:(NSInteger)offset;
- (NSIndexPath *)indexPathByOffsettingSection:(NSInteger)offset;

@end
