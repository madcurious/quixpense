//
//  SPRCategoryCollectionViewCell.m
//  Spare
//
//  Created by Matt Quiros on 4/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryCollectionViewCell.h"

// Categories
#import "UIColor+HexColor.h"

// Objects
#import "SPRCategory+Extension.h"

static const CGFloat kCellWidth = 145;
static const CGFloat kInnerMargin = 5;
static const CGFloat kLabelWidth = kCellWidth - kInnerMargin * 2;

@interface SPRCategoryCollectionViewCell ()

@property (strong, nonatomic) UILabel *categoryLabel;

@end

@implementation SPRCategoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.textColor = [UIColor colorFromHex:0x3b3b3b];
        _categoryLabel.font = [UIFont boldSystemFontOfSize:17];
        _categoryLabel.numberOfLines = 0;
        _categoryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:_categoryLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.categoryLabel sizeToFitWidth:kLabelWidth];
    self.categoryLabel.frame = CGRectMake(kInnerMargin, kInnerMargin, kLabelWidth, self.categoryLabel.frame.size.height);
}

- (void)setCategory:(SPRCategory *)category
{
    _category = category;
    
    self.categoryLabel.text = category.name;
    self.backgroundColor = [SPRCategory colors][[category.colorNumber integerValue]];
    
    [self setNeedsLayout];
}

@end
