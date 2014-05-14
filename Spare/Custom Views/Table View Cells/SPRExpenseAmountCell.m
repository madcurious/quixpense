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

@interface SPRExpenseAmountCell ()

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
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.contentView addSubview:_textField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [self.fieldLabel sizeToFitWidth:kSPRFormFieldLabelWidth];
    CGFloat descriptionLabelY = [self.fieldLabel centerYInParent:self];
    self.fieldLabel.frame = CGRectMake(kSPRFormSideMargin, descriptionLabelY, kSPRFormFieldLabelWidth, self.fieldLabel.frame.size.height);
    
    [self.textField sizeToFitWidth:kSPRFormRightComponentWidth];
    CGFloat textFieldY = [self.textField centerYInParent:self];
    self.textField.frame = CGRectMake(kSPRFormRightComponentX, textFieldY, kSPRFormRightComponentWidth, self.textField.frame.size.height);
}

@end
