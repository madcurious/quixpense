//
//  SPRCategoryPickerView.h
//  Spare
//
//  Created by Matt Quiros on 4/1/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategoryPicker, SPRCategory;

@protocol SPRCategoryPickerDelegate <NSObject>

- (void)categoryPicker:(SPRCategoryPicker *)categoryPicker didSelectCategory:(SPRCategory *)category;

- (void)categoryPickerWillDisappear:(SPRCategoryPicker *)categoryPicker;

@end

@interface SPRCategoryPicker : UIView

@property (weak, nonatomic) id<SPRCategoryPickerDelegate> delegate;
@property (strong, nonatomic) SPRCategory *preselectedCategory;

- (void)show;

@end
