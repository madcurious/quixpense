//
//  SPRDatePickerView.m
//  Spare
//
//  Created by Matt Quiros on 4/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRDatePicker.h"

static const CGFloat kAnimationDuration = 0.1;

@interface SPRDatePicker ()

@property (strong, nonatomic) UIView *translucentBackground;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation SPRDatePicker

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _translucentBackground = [[UIView alloc] init];
        _translucentBackground.backgroundColor = [UIColor blackColor];
        _translucentBackground.alpha = 0.3;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_translucentBackground addGestureRecognizer:tapRecognizer];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_translucentBackground];
        [self addSubview:_datePicker];
        self.alpha = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    self.translucentBackground.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.datePicker.frame = CGRectMake(0, self.frame.size.height - self.datePicker.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
}

- (void)show
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - Target action

- (void)datePickerChanged
{
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        NSDate *simplifiedDate = [NSDate simplifiedDateFromDate:self.datePicker.date];
        [self.delegate datePicker:self didSelectDate:simplifiedDate];
    }
}

- (void)hide
{
    if ([self.delegate respondsToSelector:@selector(datePickerWillDisappear:)]) {
        [self.delegate datePickerWillDisappear:self];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setters

- (void)setPreselectedDate:(NSDate *)preselectedDate
{
    _preselectedDate = preselectedDate;
    self.datePicker.date = preselectedDate;
}

@end
