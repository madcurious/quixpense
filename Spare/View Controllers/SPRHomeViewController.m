//
//  SPRHomeViewController.m
//  Spare
//
//  Created by Matt Quiros on 4/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeViewController.h"

// Utilities
#import "SPRIconFont.h"

// Custom views
#import "SPRStatusView.h"
#import "SPRCategoryCollectionViewCell.h"

// View controllers
#import "SPRNewCategoryViewController.h"
#import "SPRCategoryViewController.h"

// Objects
#import "SPRCategory+Extension.h"

// Pods
#import "LXReorderableCollectionViewFlowLayout.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface SPRHomeViewController () <LXReorderableCollectionViewDataSource, UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout, SPRNewCategoryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SPRStatusView *statusView;

@property (strong, nonatomic) NSArray *categories;
@property (nonatomic) NSInteger selectedCategoryIndex;

@end

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = nil;
    
    UIButton *newCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newCategoryButton setAttributedTitle:[SPRIconFont iconForNewCategory] forState:UIControlStateNormal];
    [newCategoryButton sizeToFit];
    [newCategoryButton addTarget:self action:@selector(newCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCategoryButton];
    
    self.navigationItem.rightBarButtonItems = @[newCategoryBarButtonItem];
    
    [self.collectionView registerClass:[SPRCategoryCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.categories == nil) {
        [self reloadTableView];
    }
}

- (void)reloadTableView
{
    // If the categories array is nil or has zero count,
    // the table view is not visible in the screen and we can therefore put
    // a status view on top of it.
//    if (self.categories == nil || self.categories.count == 0) {
//        [self.view addSubview:self.statusView];
//        self.statusView.status = SPRStatusViewStatusLoading;
//    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    __weak SPRHomeViewController *weakSelf = self;
//    [SPRCategory enumerateAllCategoriesWithCompletion:^(NSArray *categories, NSError *error) {
//        SPRHomeViewController *innerSelf = weakSelf;
//        
//        if (error) {
//            NSLog(@"Error fetching all categories: %@", error);
//        } else {
//            innerSelf.categories = categories;
//            
//            if (categories.count > 0) {
//                [innerSelf.statusView fadeOutAndRemoveFromSuperview];
//                [innerSelf.collectionView reloadData];
//            } else {
//                innerSelf.statusView.status = SPRStatusViewStatusNoResults;
//            }
//        }
//        
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    }];
    
    self.categories = [SPRCategory allCategories];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewCategoryModal"]) {
        UINavigationController *modalNavigationController = segue.destinationViewController;
        
        SPRNewCategoryViewController *newCategoryScreen = modalNavigationController.viewControllers[0];
        newCategoryScreen.delegate = self;
        return;
    }
    
    if ([segue.identifier isEqualToString:@"pushCategory"]) {
        SPRCategoryViewController *categoryScreen = segue.destinationViewController;
        categoryScreen.categoryIndex = self.selectedCategoryIndex;
        return;
    }
}

#pragma mark - Target actions

- (void)newCategoryButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewCategoryModal" sender:self];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Get the category at the index path.
    SPRCategory *category = self.categories[indexPath.row];
    
    cell.category = category;
    
    return cell;
}

#pragma mark - LXReorderableCollectionView data source

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCategoryIndex = indexPath.row;
    [self performSegueWithIdentifier:@"pushCategory" sender:self];
}

#pragma mark - New category view controller delegate

- (void)newCategoryViewControllerDidAddCategory
{
    [self reloadTableView];
}

#pragma mark - Getters

- (SPRStatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[SPRStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _statusView.noResultsText = @"You have no categories yet.";
    }
    return _statusView;
}

@end
