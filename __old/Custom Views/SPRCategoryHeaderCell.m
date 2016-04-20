//
//  SPRCategoryHeaderCell.m
//  Spare
//
//  Created by Matt Quiros on 5/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryHeaderCell.h"

// Objects
#import "SPRCategory+Extension.h"

@interface SPRCategoryHeaderCell ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation SPRCategoryHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [SPRCategoryHeaderCell label];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.label sizeToFitWidth:300];
    self.label.frame = CGRectMake(10, 10, 300, self.label.frame.size.height);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.label.frame.size.height + 20);
}

- (void)setCategory:(SPRCategory *)category
{
    _category = category;
    
    self.backgroundColor = [SPRCategory colors][[category.colorNumber integerValue]];
    self.label.text = category.name;
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCategory:(SPRCategory *)category
{
    UILabel *label = [SPRCategoryHeaderCell label];
    label.text = category.name;
    [label sizeToFitWidth:300];
    
    CGFloat height = label.frame.size.height + 10 * 2;
    return height;
}

+ (UILabel *)label
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

@end
