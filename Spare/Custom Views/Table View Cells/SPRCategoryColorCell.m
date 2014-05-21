//
//  SPRCategoryColorCell.m
//  Spare
//
//  Created by Matt Quiros on 5/21/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryColorCell.h"

// Utilities
#import "SPRFormComponents.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRField.h"

static const CGFloat kColorViewHeight = 26;

@interface SPRCategoryColorCell ()

@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UIView *colorView;

@end

@implementation SPRCategoryColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _fieldLabel = [SPRFormComponents fieldLabelWithTitle:@"Color"];
        [self.contentView addSubview:_fieldLabel];
        
        _colorView = [[UIView alloc] init];
        [self.contentView addSubview:_colorView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat fieldLabelY = [self.fieldLabel centerYInParent:self];
    self.fieldLabel.frame = CGRectMake(kSPRFormSideMargin, fieldLabelY, kSPRFormFieldLabelWidth, self.fieldLabel.intrinsicContentSize.height);
    
    CGFloat colorViewY = self.frame.size.height / 2 - kColorViewHeight / 2;
    self.colorView.frame = CGRectMake(kSPRFormRightComponentX, colorViewY, kSPRFormRightComponentWidth, kColorViewHeight);
}

- (void)setField:(SPRField *)field
{
    super.field = field;
    self.colorView.backgroundColor = (UIColor *)[[SPRCategory colors] objectAtIndex:[field.value integerValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Reassert the background color of the color view so that it shows
    // even when the cell is highlighted for selection.
    self.colorView.backgroundColor = (UIColor *)[[SPRCategory colors] objectAtIndex:[self.field.value integerValue]];
}

@end
