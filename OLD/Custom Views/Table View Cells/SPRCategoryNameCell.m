//
//  SPRCategoryNameCell.m
//  Spare
//
//  Created by Matt Quiros on 5/21/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryNameCell.h"

// Utilities
#import "SPRFormComponents.h"

// Objects
#import "SPRField.h"

@interface SPRCategoryNameCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation SPRCategoryNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Name"];
        [self.contentView addSubview:_fieldLabel];
        
        _textField = [SPRFormComponents textField];
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat fieldLabelY = [self.fieldLabel centerYInParent:self];
    self.fieldLabel.frame = CGRectMake(kSPRFormSideMargin, fieldLabelY, kSPRFormFieldLabelWidth, self.fieldLabel.intrinsicContentSize.height);
    
    CGFloat textFieldY = [self.textField centerYInParent:self];
    self.textField.frame = CGRectMake(kSPRFormRightComponentX, textFieldY, kSPRFormRightComponentWidth, self.textField.intrinsicContentSize.height);
}

- (void)setField:(SPRField *)field
{
    [super setField:field];
    self.textField.text = field.value;
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.field.value = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.field.value = nil;
    return YES;
}

@end
