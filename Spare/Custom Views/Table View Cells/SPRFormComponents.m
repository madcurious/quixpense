//
//  SPRFormComponents.m
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRFormComponents.h"

// Categories
#import "UIColor+HexColor.h"

// Dimensions and margins.
const CGFloat kSPRFormSideMargin = 15;
const CGFloat kSPRFormFieldLabelWidth = 91;
const CGFloat kSPRFormMiddleMargin = 5;
const CGFloat kSPRFormRightComponentX = kSPRFormSideMargin + kSPRFormFieldLabelWidth + kSPRFormMiddleMargin;
const CGFloat kSPRFormRightComponentWidth = 194;

@implementation SPRFormComponents

+ (UILabel *)fieldLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 1;
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorFromHex:0x007aff];
    return label;
}

+ (UITextField *)textField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"Tap to edit";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

+ (UILabel *)valueLabel
{
    UILabel *label = [[UILabel alloc] init];
//    label.font = [UIFont systemFontOfSize:17];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 1;
//    label.textColor = [UIColor blackColor];
    return label;
}

@end
