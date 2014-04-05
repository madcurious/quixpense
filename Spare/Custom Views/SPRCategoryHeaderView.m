//
//  SPRCategoryHeaderView.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryHeaderView.h"

// Objects
#import "SPRCategory+Extension.h"

@interface SPRCategoryHeaderView ()

@property (strong, nonatomic) UILabel *label;

@end

static const CGFloat kInnerMargin = 10;
static const CGFloat kMaxContentWidth = 300;

@implementation SPRCategoryHeaderView

- (id)initWithCategory:(SPRCategory *)category
{
    UILabel *label = [SPRCategoryHeaderView label];
    label.text = category.name;
    [label sizeToFitWidth:kMaxContentWidth];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, label.frame.size.height + kInnerMargin * 2)]) {
        _label = label;
        [self addSubview:_label];
        
        self.backgroundColor = [SPRCategory colors][[category.colorNumber integerValue]];
    }
    return self;
}

- (void)layoutSubviews
{
    self.label.frame = CGRectMake(kInnerMargin, kInnerMargin, kMaxContentWidth, self.label.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.label.frame.size.height + kInnerMargin * 2);
}

#pragma mark -

+ (UILabel *)label
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

@end
