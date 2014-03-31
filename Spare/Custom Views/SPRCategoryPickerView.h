//
//  SPRCategoryPickerView.h
//  Spare
//
//  Created by Matt Quiros on 4/1/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategoryPickerView, SPRCategory;

@protocol SPRCategoryPickerViewDelegate <NSObject>

- (void)categoryPickerView:(SPRCategoryPickerView *)categoryPickerView didSelectCategory:(SPRCategory *)category;

- (void)willDismissCategoryPickerView:(SPRCategoryPickerView *)categoryPickerView;

@end

@interface SPRCategoryPickerView : UIView

@property (weak, nonatomic) id<SPRCategoryPickerViewDelegate> delegate;
//@property (strong, nonatomic) SPRCategory *preselectedCategory;
@property (nonatomic) NSInteger preselectedRow;

- (void)show;

@end
