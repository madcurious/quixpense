//
//  SPRCategorySectionHeader.h
//  Spare
//
//  Created by Matt Quiros on 4/14/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat SPRCategorySectionHeaderHeight;

@interface SPRCategorySectionHeader : UIView

- (instancetype)initWithDate:(NSDate *)date total:(NSDecimalNumber *)total;

@end
