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
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *todayLabel;

@end

static const CGFloat kInnerMargin = 10;
static const CGFloat kMaxContentWidth = 300;

@implementation SPRHomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [SPRHomeTableViewCell nameLabel];
        _priceLabel = [SPRHomeTableViewCell priceLabel];
        _todayLabel = [SPRHomeTableViewCell todayLabel];
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_todayLabel];
    }
    return self;
}

- (void)setCategory:(SPRCategory *)category
{
    _category = category;
    
    self.nameLabel.text = category.name;
}

- (void)layoutSubviews
{
    [self.nameLabel sizeToFitWidth:kMaxContentWidth];
    self.nameLabel.frame = CGRectMake(kInnerMargin, kInnerMargin, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    CGFloat priceLabelY = kInnerMargin + self.nameLabel.frame.size.height + 10;
    [self.priceLabel sizeToFitWidth:kMaxContentWidth];
    self.priceLabel.frame = CGRectMake(kInnerMargin, priceLabelY, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    
    CGFloat todayLabelY = priceLabelY + self.priceLabel.frame.size.height + 10;
    self.todayLabel.frame = CGRectMake(kInnerMargin, todayLabelY, self.todayLabel.frame.size.width, self.todayLabel.frame.size.height);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, todayLabelY + self.todayLabel.frame.size.height + 10);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentView.frame.size.height);
}

#pragma mark - Static methods

+ (UILabel *)nameLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.font = [UIFont systemFontOfSize:30];
    return nameLabel;
}

+ (UILabel *)priceLabel
{
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.numberOfLines = 1;
    priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.text = [[NSNumber numberWithDouble:15244.50f] currencyString];
    return priceLabel;
}

+ (UILabel *)todayLabel
{
    UILabel *todayLabel = [[UILabel alloc] init];
    todayLabel.numberOfLines = 1;
    todayLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    todayLabel.font = [UIFont systemFontOfSize:14];
    todayLabel.text = @"TODAY";
    [todayLabel sizeToFitWidth:kMaxContentWidth];
    return todayLabel;
}

+ (CGFloat)heightForCategory:(SPRCategory *)category
{
    CGFloat height = kInnerMargin;
    
    UILabel *nameLabel = [SPRHomeTableViewCell nameLabel];
    nameLabel.text = category.name;
    [nameLabel sizeToFitWidth:kMaxContentWidth];
    height += nameLabel.frame.size.height;
    
    height += 10;
    
    UILabel *priceLabel = [SPRHomeTableViewCell priceLabel];
    [priceLabel sizeToFitWidth:kMaxContentWidth];
    height += priceLabel.frame.size.height;
    
    height += 10;
    
    UILabel *todayLabel = [SPRHomeTableViewCell todayLabel];
    [todayLabel sizeToFitWidth:kMaxContentWidth];
    height += todayLabel.frame.size.height;
    
    height += kInnerMargin;
    
    return height;
}

@end
