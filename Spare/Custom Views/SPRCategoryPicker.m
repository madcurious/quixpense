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
#import "SPRManagedDocument.h"

static const CGFloat kPickerViewHeight = 162;
static const CGFloat kAnimationDuration = 0.1;

@interface SPRCategoryPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIView *translucentBackground;
@property (strong, nonatomic) UIActivityIndicatorView *loadingAnimation;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;

@end

@implementation SPRCategoryPicker

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([SPRCategory class])];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        _categoryFetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SPRManagedDocument sharedDocument] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        [_categoryFetcher performFetch:nil];
        
        _loadingAnimation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingAnimation.alpha = 1;
        [_loadingAnimation startAnimating];
        [self addSubview:_loadingAnimation];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.translucentBackground.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    //    if (self.categoryFetcher.fe == nil) {
    CGFloat loadingAnimationX = self.frame.size.width / 2 - self.loadingAnimation.frame.size.width / 2;
    CGFloat loadingAnimationY = self.frame.size.height / 2 - self.loadingAnimation.frame.size.height / 2;
    self.loadingAnimation.frame = CGRectMake(loadingAnimationX, loadingAnimationY, self.loadingAnimation.frame.size.width, self.loadingAnimation.frame.size.height);
    //    }
    
    self.pickerView.frame = CGRectMake(0, self.frame.size.height - kPickerViewHeight, self.frame.size.width, kPickerViewHeight);
}

- (void)show
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self.pickerView reloadAllComponents];
        
        // If there is a pre-selected category, select it.
        // Otherwise, pre-select the category in the middle.
        if (self.preselectedCategory) {
            [self.pickerView selectRow:[self.preselectedCategory.displayOrder integerValue] inComponent:0 animated:NO];
        } else {
            // Compute for the middle index and select it.
            double count = (double)self.categoryFetcher.fetchedObjects.count;
            NSInteger row = ceil(count / 2) - 1;
            [self.pickerView selectRow:row inComponent:0 animated:NO];
            
            // Tell the delegate that the middle category was selected.
            if ([self.delegate respondsToSelector:@selector(categoryPicker:didSelectCategory:)]) {
                [self.delegate categoryPicker:self didSelectCategory:self.categoryFetcher.fetchedObjects[row]];
            }
        }
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.loadingAnimation.alpha = 0;
            self.pickerView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.loadingAnimation stopAnimating];
        }];
    }];
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
    return self.categoryFetcher.fetchedObjects.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SPRCategory *category = self.categoryFetcher.fetchedObjects[row];
    return category.name;
}

#pragma mark - Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(categoryPicker:didSelectCategory:)]) {
        [self.delegate categoryPicker:self didSelectCategory:self.categoryFetcher.fetchedObjects[row]];
    }
}

#pragma mark - Setters

- (void)setPreselectedCategory:(SPRCategory *)preselectedCategory
{
    _preselectedCategory = preselectedCategory;
}

@end
