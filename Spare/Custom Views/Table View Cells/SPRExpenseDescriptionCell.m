//
//  SPRExpenseDescriptionCell.m
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseDescriptionCell.h"

// Utilities
#import "SPRFormComponents.h"

@interface SPRExpenseDescriptionCell ()

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation SPRExpenseDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Description"];
        [self.contentView addSubview:_fieldLabel];
        
        _textField = [SPRFormComponents textField];
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

@end
