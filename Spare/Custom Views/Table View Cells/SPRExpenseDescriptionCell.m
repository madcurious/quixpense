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

@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation SPRExpenseDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _descriptionLabel = [SPRFormComponents fieldLabelWithTitle:@"Description"];
        [self.contentView addSubview:_descriptionLabel];
        
        _textField = [SPRFormComponents textField];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.descriptionLabel sizeToFitWidth:kSPRFormFieldLabelWidth];
    CGFloat descriptionLabelY = [self.descriptionLabel centerYInParent:self];
    self.descriptionLabel.frame = CGRectMake(kSPRFormSideMargin, descriptionLabelY, kSPRFormFieldLabelWidth, self.descriptionLabel.frame.size.height);
    
    [self.textField sizeToFitWidth:kSPRFormRightComponentWidth];
    CGFloat textFieldY = [self.textField centerYInParent:self];
    self.textField.frame = CGRectMake(kSPRFormRightComponentX, textFieldY, kSPRFormRightComponentWidth, self.textField.frame.size.height);
}

@end
