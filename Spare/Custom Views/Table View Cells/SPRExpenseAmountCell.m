//
//  SPRExpenseAmountCell.m
//  Spare
//
//  Created by Matt Quiros on 5/11/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseAmountCell.h"

// Utilities
#import "SPRFormComponents.h"

// Objects
#import "SPRField.h"

@interface SPRExpenseAmountCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation SPRExpenseAmountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Amount"];
        [self.contentView addSubview:_fieldLabel];
        
        _textField = [SPRFormComponents textField];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.contentView addSubview:_textField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat descriptionLabelY = [self.fieldLabel centerYInParent:self];
    self.fieldLabel.frame = CGRectMake(kSPRFormSideMargin, descriptionLabelY, kSPRFormFieldLabelWidth, self.fieldLabel.intrinsicContentSize.height);
    
    CGFloat textFieldY = [self.textField centerYInParent:self];
    self.textField.frame = CGRectMake(kSPRFormRightComponentX, textFieldY, kSPRFormRightComponentWidth, self.textField.intrinsicContentSize.height);
}

- (void)setField:(SPRField *)field
{
    [super setField:field];
    
    self.textField.text = [field.value stringValue];
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *invalidCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    if ([string intersectsWithCharacterSet:invalidCharacterSet]) {
        return NO;
    }
    
    NSString *amountText = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    self.field.value = amountText;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.field.value = @"";
    return YES;
}

@end
