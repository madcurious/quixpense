//
//  SPRCategory.h
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRCategory : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *colorNumber;

- (id)initWithName:(NSString *)name colorNumber:(NSNumber *)colorNumber;

+ (NSArray *)dummies;
+ (NSArray *)colors;

@end