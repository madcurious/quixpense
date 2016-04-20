//
//  SPRExpenseDateSpentCell.m
//  Spare
//
//  Created by Matt Quiros on 5/15/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRExpenseDateSpentCell.h"

// Utilities
#import "SPRFormComponents.h"

// Objects
#import "SPRField.h"

@interface SPRExpenseDateSpentCell ()

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation SPRExpenseDateSpentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Date spent"];
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

- (void)setField:(SPRField *)field
{
    [super setField:field];
    
    NSDate *dateSpent = field.value;
    self.valueLabel.text = dateSpent.textInForm;
    
    [self setNeedsLayout];
}

@end
