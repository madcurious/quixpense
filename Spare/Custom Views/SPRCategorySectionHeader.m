//
//  SPRCategorySectionHeader.m
//  Spare
//
//  Created by Matt Quiros on 4/14/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategorySectionHeader.h"

// Categories
#import "UIColor+HexColor.h"

const CGFloat SPRCategorySectionHeaderHeight = 22;

@interface SPRCategorySectionHeader ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *totalLabel;

@end

@implementation SPRCategorySectionHeader

- (instancetype)initWithDate:(NSDate *)date total:(NSDecimalNumber *)total
{
    if (self = [super init]) {
        static NSDateFormatter *sectionDateFormatter = nil;
        
        if (!sectionDateFormatter) {
            sectionDateFormatter = [[NSDateFormatter alloc] init];
            sectionDateFormatter.calendar = [NSCalendar currentCalendar];
        }
        
        NSString *dateLabelText;
        
        if ([date isSameDayAsDate:[NSDate date]]) {
            sectionDateFormatter.dateFormat = @"'Today,' MMM dd";
        } else {
            sectionDateFormatter.dateFormat = @"EEE, MMM dd";
        }
        dateLabelText = [sectionDateFormatter stringFromDate:date];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
        _dateLabel.text = [NSString stringWithString:dateLabelText];
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont boldSystemFontOfSize:14];
        _totalLabel.text = [total currencyString];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        
        [self addSubview:_dateLabel];
        [self addSubview:_totalLabel];
        
        self.backgroundColor = [UIColor colorFromHex:0xeeeeee];
    }
    return self;
}

- (void)layoutSubviews
{
    static const CGFloat kSideMargin = 15;
    static const CGFloat kSpaceBetweenLabels = 10;
    static const CGFloat kDateLabelWidthPercent = .5;
    static const CGFloat kTotalLabelWidthPercent = .5;
    static const CGFloat kFreeWidth = 320 - (kSideMargin * 2 + kSpaceBetweenLabels);
    static const CGFloat kDateLabelWidth = kFreeWidth * kDateLabelWidthPercent;
    static const CGFloat kTotalLabelWidth = kFreeWidth * kTotalLabelWidthPercent;
    
    [self.dateLabel sizeToFitWidth:kDateLabelWidth];
    CGFloat dateLabelY = SPRCategorySectionHeaderHeight / 2 - self.dateLabel.frame.size.height / 2;
    self.dateLabel.frame = CGRectMake(kSideMargin, dateLabelY, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
    
    static const CGFloat kTotalLabelX = kSideMargin + kDateLabelWidth + kSpaceBetweenLabels;
    
    [self.totalLabel sizeToFitWidth:kTotalLabelWidth];
    CGFloat totalLabelY = SPRCategorySectionHeaderHeight / 2 - self.totalLabel.frame.size.height / 2;
    self.totalLabel.frame = CGRectMake(kTotalLabelX, totalLabelY, self.totalLabel.frame.size.width, self.totalLabel.frame.size.height);
    
//    [self.totalLabel sizeToFitWidth:kTotalLabelWidth];
//    CGFloat totalLabelY = SPRCategorySectionHeaderHeight / 2 - self.totalLabel.frame.size.height / 2;
//    self.totalLabel.frame = CGRectMake(kSideMargin, totalLabelY, self.totalLabel.frame.size.width, self.totalLabel.frame.size.height);
//    
//    static const CGFloat kDateLabelX = kSideMargin + kTotalLabelWidth + kSpaceBetweenLabels;
//    
//    [self.dateLabel sizeToFitWidth:kDateLabelWidth];
//    CGFloat dateLabelY = SPRCategorySectionHeaderHeight / 2 - self.dateLabel.frame.size.height / 2;
//    self.dateLabel.frame = CGRectMake(kDateLabelX, dateLabelY, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, SPRCategorySectionHeaderHeight);
}

@end
