//
//  SPRFormComponents.h
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const CGFloat kSPRFormSideMargin;
extern const CGFloat kSPRFormFieldLabelWidth;
extern const CGFloat kSPRFormMiddleMargin;
extern const CGFloat kSPRFormRightComponentX;
extern const CGFloat kSPRFormRightComponentWidth;

@interface SPRFormComponents : NSObject

+ (UILabel *)fieldLabelWithTitle:(NSString *)title;
+ (UITextField *)textField;
+ (UILabel *)valueLabel;

@end
