//
//  SPRDatePickerView.h
//  Spare
//
//  Created by Matt Quiros on 4/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRDatePicker;

@protocol SPRDatePickerDelegate <NSObject>

- (void)datePickerWillDisappear:(SPRDatePicker *)datePicker;
- (void)datePicker:(SPRDatePicker *)datePicker didSelectDate:(NSDate *)date;

@end

@interface SPRDatePicker : UIView

@property (weak, nonatomic) id<SPRDatePickerDelegate> delegate;
@property (strong, nonatomic) NSDate *preselectedDate;

- (void)show;

@end
