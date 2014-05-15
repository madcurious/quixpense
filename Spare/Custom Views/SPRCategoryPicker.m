//
//  SPRCategoryPickerView.m
//  Spare
//
//  Created by Matt Quiros on 4/1/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryPicker.h"

// Objects
#import "SPRCategory+Extension.h"

static const CGFloat kPickerViewHeight = 162;
static const CGFloat kAnimationDuration = 0.1;

static NSArray *allCategories;

@interface SPRCategoryPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIView *translucentBackground;
@property (strong, nonatomic) UIActivityIndicatorView *loadingAnimation;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation SPRCategoryPicker

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _preselectedRow = -1;
        
        _translucentBackground = [[UIView alloc] init];
        _translucentBackground.backgroundColor = [UIColor blackColor];
        _translucentBackground.alpha = 0.3;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_translucentBackground addGestureRecognizer:tapGestureRecognizer];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.alpha = 0;
        
        [self addSubview:_translucentBackground];
        [self addSubview:_pickerView];
        self.alpha = 0;
        
        if (allCategories == nil) {
            _loadingAnimation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _loadingAnimation.alpha = 1;
            [_loadingAnimation startAnimating];
            [self addSubview:_loadingAnimation];
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.translucentBackground.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (allCategories == nil) {
        CGFloat loadingAnimationX = self.frame.size.width / 2 - self.loadingAnimation.frame.size.width / 2;
        CGFloat loadingAnimationY = self.frame.size.height / 2 - self.loadingAnimation.frame.size.height / 2;
        self.loadingAnimation.frame = CGRectMake(loadingAnimationX, loadingAnimationY, self.loadingAnimation.frame.size.width, self.loadingAnimation.frame.size.height);
    }

    self.pickerView.frame = CGRectMake(0, self.frame.size.height - kPickerViewHeight, self.frame.size.width, kPickerViewHeight);
}

- (void)show
{
    if (allCategories == nil) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            allCategories = [SPRCategory allCategories];
            [self.pickerView reloadAllComponents];
            
            // If there is a pre-selected category, select it.
            // Otherwise, pre-select the category in the middle.
            if (self.preselectedRow == -1) {
                NSInteger row = allCategories.count / 2;
                [self.pickerView selectRow:row inComponent:0 animated:NO];
            } else {
                [self.pickerView selectRow:self.preselectedRow inComponent:0 animated:NO];
            }
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.loadingAnimation.alpha = 0;
                self.pickerView.alpha = 1;
            } completion:^(BOOL finished) {
                [self.loadingAnimation stopAnimating];
            }];
        }];
    } else {
        [self.pickerView reloadAllComponents];
        self.pickerView.alpha = 1;
        
        // If there is a pre-selected category, select it.
        // Otherwise, pre-select the category in the middle.
        if (self.preselectedRow == -1) {
            NSInteger row = allCategories.count / 2;
            [self.pickerView selectRow:row inComponent:0 animated:NO];
        } else {
            [self.pickerView selectRow:self.preselectedRow inComponent:0 animated:NO];
        }
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)hide
{
    if ([self.delegate respondsToSelector:@selector(categoryPickerWillDisappear:)]) {
        [self.delegate categoryPickerWillDisappear:self];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return allCategories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SPRCategory *category = allCategories[row];
    return category.name;
}

#pragma mark - Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(categoryPicker:didSelectCategory:)]) {
        [self.delegate categoryPicker:self didSelectCategory:allCategories[row]];
    }
}

#pragma mark - Setters

- (void)setPreselectedCategory:(SPRCategory *)preselectedCategory
{
    _preselectedCategory = preselectedCategory;
    self.preselectedRow = [preselectedCategory.displayOrder integerValue];
}

@end
