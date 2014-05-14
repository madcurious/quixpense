//
//  SPRExpenseCategoryCell.m
//  Spare
//
//  Created by Matt Quiros on 5/15/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseCategoryCell.h"

// Utilities
#import "SPRFormComponents.h"

@interface SPRExpenseCategoryCell ()

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation SPRExpenseCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Category"];
        [self.contentView addSubview:_fieldLabel];
        
        _valueLabel = [SPRFormComponents valueLabel];
        [self.contentView addSubview:_valueLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat fieldLabelY = [self.fieldLabel centerYInParent:self];
    self.fieldLabel.frame = CGRectMake(kSPRFormSideMargin, fieldLabelY, kSPRFormFieldLabelWidth, self.fieldLabel.intrinsicContentSize.height);
    
    CGFloat valueLabelY = [self.valueLabel centerYInParent:self];
    self.valueLabel.frame = CGRectMake(kSPRFormRightComponentX, valueLabelY, kSPRFormRightComponentWidth, self.valueLabel.intrinsicContentSize.height);
}

@end
