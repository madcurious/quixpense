//
//  SPRExpenseSectionHeader.h
//  Spare
//
//  Created by Matt Quiros on 6/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRExpenseSectionHeader : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *total;

- (instancetype)initWithDate:(NSDate *)date;

@end
