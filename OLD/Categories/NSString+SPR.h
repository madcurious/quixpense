//
//  NSString+SPR.h
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SPR)

- (NSString *)trim;

- (BOOL)intersectsWithCharacterSet:(NSCharacterSet *)characterSet;

@end