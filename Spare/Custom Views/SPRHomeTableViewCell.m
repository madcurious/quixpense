//
//  SPRHomeTableViewCell.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeTableViewCell.h"

// Objects
#import "SPRCategory.h"

@interface SPRHomeTableViewCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *amountLabel;

@end

static const CGFloat kInnerMargin = 10;
static const CGFloat kMaxContentWidth = 300;
static const CGFloat kSpaceBetweenNameAndAmount = 10;

@implementation SPRHomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [SPRHomeTableViewCell nameLabel];
        _amountLabel = [SPRHomeTableViewCell amountLabel];
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_amountLabel];
    }
    return self;
}

- (void)setCategory:(SPRCategory *)category
{
    _category = category;
    
    self.nameLabel.text = [category.name uppercaseString];
    
    self.backgroundColor = (UIColor *)[SPRCategory colors][[category.colorNumber integerValue]];
}

- (void)layoutSubviews
{
    [self.nameLabel sizeToFitWidth:kMaxContentWidth];
    self.nameLabel.frame = CGRectMake(kInnerMargin, kInnerMargin, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    CGFloat amountLabelY = kInnerMargin + self.nameLabel.frame.size.height + kSpaceBetweenNameAndAmount;
    [self.amountLabel sizeToFitWidth:kMaxContentWidth];
    self.amountLabel.frame = CGRectMake(kInnerMargin, amountLabelY, self.amountLabel.frame.size.width, self.amountLabel.frame.size.height);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, amountLabelY + self.amountLabel.frame.size.height + kInnerMargin);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentView.frame.size.height);
}

#pragma mark - Static methods

+ (UILabel *)nameLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    return nameLabel;
}

+ (UILabel *)amountLabel
{
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.numberOfLines = 1;
    amountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    amountLabel.font = [UIFont systemFontOfSize:18];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = [[NSNumber numberWithDouble:15244.50f] currencyString];
    return amountLabel;
}

+ (CGFloat)heightForCategory:(SPRCategory *)category
{
    CGFloat height = kInnerMargin;
    
    UILabel *nameLabel = [SPRHomeTableViewCell nameLabel];
    nameLabel.text = [category.name uppercaseString];
    [nameLabel sizeToFitWidth:kMaxContentWidth];
    height += nameLabel.frame.size.height;
    
    height += kSpaceBetweenNameAndAmount;
    
    UILabel *amountLabel = [SPRHomeTableViewCell amountLabel];
    [amountLabel sizeToFitWidth:kMaxContentWidth];
    height += amountLabel.frame.size.height;
    
    height += kInnerMargin;
    
    return height;
}

@end
