//
//  SPRField.h
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRField : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) id value;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name value:(id)value;
- (instancetype)initWithValue:(id)value;

@end