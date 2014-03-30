//
//  NSDate+SPR.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SPR)

- (BOOL)isSameDayAsDate:(NSDate *)date;
- (NSString *)textInForm;

@end
