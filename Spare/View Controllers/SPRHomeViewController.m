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
#import "SPRManagedDocument.h"
#import "SPRExpense.h"

// Pods
#import "LXReorderableCollectionViewFlowLayout.h"

// Constants
#import "SPRTimeFrame.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface SPRHomeViewController () <LXReorderableCollectionViewDataSource, UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SPRStatusView *statusView;
@property (nonatomic) NSInteger selectedCategoryIndex;
@property (nonatomic) BOOL hasBeenSetup;

@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;

@property (strong, nonatomic) NSMutableArray *dailyTotals;
@property (strong, nonatomic) NSMutableArray *weeklyTotals;
@property (strong, nonatomic) NSMutableArray *monthlyTotals;
@property (strong, nonatomic) NSMutableArray *yearlyTotals;
@property (strong, nonatomic, readonly) NSMutableArray *activeTotals;

@property (nonatomic) SPRTimeFrame activeTimeFrame;

@end

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the bar button item.s
    [self setupBarButtonItems];
    
    // Register a collection view cell class.
    [self.collectionView registerClass:[SPRCategoryCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    // By default, the active time frame for totals is daily.
    self.activeTimeFrame = SPRTimeFrameDay;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasBeenSetup) {
        [self initializeCategories];
        [self.collectionView reloadData];
    } else {
        [self performSegueWithIdentifier:@"presentSetup" sender:self];
        self.hasBeenSetup = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushCategory"]) {
        SPRCategoryViewController *categoryScreen = segue.destinationViewController;
        categoryScreen.categoryIndex = self.selectedCategoryIndex;
        return;
    }
}

#pragma mark - Helper methods

- (void)setupBarButtonItems
{
    // The new category button.
    UIButton *newCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newCategoryButton setAttributedTitle:[SPRIconFont iconForNewCategory] forState:UIControlStateNormal];
    [newCategoryButton sizeToFit];
    [newCategoryButton addTarget:self action:@selector(newCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCategoryButton];
    
    // The new expense button.
    UIButton *newExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newExpenseButton setAttributedTitle:[SPRIconFont iconForNewExpense] forState:UIControlStateNormal];
    [newExpenseButton sizeToFit];
    [newExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newExpenseButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem, newCategoryBarButtonItem];
}

- (void)initializeCategories
{
    NSError *error;
    if (![self.categoryFetcher performFetch:&error]) {
        NSLog(@"%@", error);
    }
}

#pragma mark - Target actions

- (void)newCategoryButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewCategoryModal" sender:self];
}

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpenseModal" sender:self];
}

- (IBAction)segmentedControlChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.activeTimeFrame = segmentedControl.selectedSegmentIndex;
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryFetcher.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Get the category at the index path.
    SPRCategory *category = self.categoryFetcher.fetchedObjects[indexPath.row];
    
    cell.category = category;
    cell.displayedTotal = self.activeTotals[indexPath.row];
    
    return cell;
}

#pragma mark - LXReorderableCollectionView data source

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    // Reassign the display order of categories.
    NSMutableArray *categories = [self.categoryFetcher.fetchedObjects mutableCopy];
    SPRCategory *category = categories[fromIndexPath.row];
    [categories removeObject:category];
    [categories insertObject:category atIndex:toIndexPath.row];
    
    for (int i = 0; i < categories.count; i++) {
        category = categories[i];
        category.displayOrder = @(i);
    }
    
    // Reorder the totals in all of the totals arrays.
    NSArray *totals = @[self.dailyTotals, self.weeklyTotals];
    for (NSMutableArray *array in totals) {
        NSDecimalNumber *total = array[fromIndexPath.row];
        [array removeObjectAtIndex:fromIndexPath.row];
        [array insertObject:total atIndex:toIndexPath.row];
    }
    
    // Persist the reordering into the managed document.
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self.collectionView reloadData];
    }];
}

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

#pragma mark - Fetched results controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"Controller changed");
    
    if (controller == self.categoryFetcher) {
        [self initializeCategories];
        self.dailyTotals = nil;
        self.weeklyTotals = nil;
        self.monthlyTotals = nil;
        self.yearlyTotals = nil;
    }
}

#pragma mark - Getters

- (NSMutableArray *)activeTotals
{
    switch (self.activeTimeFrame) {
        case SPRTimeFrameDay: {
            return self.dailyTotals;
        }
        case SPRTimeFrameWeek: {
            return self.weeklyTotals;
        }
        case SPRTimeFrameMonth: {
            return self.monthlyTotals;
        }
        case SPRTimeFrameYear: {
            return self.yearlyTotals;
        }
        default:
            return nil;
    }
}

- (SPRStatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[SPRStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _statusView.noResultsText = @"You have no categories yet.";
    }
    return _statusView;
}

- (NSFetchedResultsController *)categoryFetcher
{
    if (_categoryFetcher) {
        return _categoryFetcher;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRCategory class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
    
    _categoryFetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _categoryFetcher.delegate = self;
    
    return _categoryFetcher;
}

- (NSMutableArray *)dailyTotals
{
    if (!_dailyTotals) {
        _dailyTotals = [SPRHomeViewController totalsForCategories:self.categoryFetcher.fetchedObjects timeFrame:SPRTimeFrameDay];
    }
    return _dailyTotals;
}

- (NSMutableArray *)weeklyTotals
{
    if (!_weeklyTotals) {
        _weeklyTotals = [SPRHomeViewController totalsForCategories:self.categoryFetcher.fetchedObjects timeFrame:SPRTimeFrameWeek];
    }
    return _weeklyTotals;
}

- (NSMutableArray *)monthlyTotals
{
    if (!_monthlyTotals) {
        _monthlyTotals = [SPRHomeViewController totalsForCategories:self.categoryFetcher.fetchedObjects timeFrame:SPRTimeFrameMonth];
    }
    return _monthlyTotals;
}

- (NSMutableArray *)yearlyTotals
{
    if (!_yearlyTotals) {
        _yearlyTotals = [SPRHomeViewController totalsForCategories:self.categoryFetcher.fetchedObjects timeFrame:SPRTimeFrameYear];
    }
    return _yearlyTotals;
}

#pragma mark -

+ (NSMutableArray *)totalsForCategories:(NSArray *)categories timeFrame:(SPRTimeFrame)timeFrame
{
    NSMutableArray *totals = [NSMutableArray array];
    
    NSFetchedResultsController *fetcher;
    
    for (int i = 0; i < categories.count; i++) {
        fetcher = [SPRHomeViewController totalFetcherForCategory:categories[i] timeFrame:timeFrame];
        [fetcher performFetch:nil];
        
        NSDictionary *dictionary = fetcher.fetchedObjects[0];
        totals[i] = dictionary[@"total"];
    }
    
    return totals;
}

+ (NSFetchedResultsController *)totalFetcherForCategory:(SPRCategory *)category timeFrame:(SPRTimeFrame)timeFrame
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRExpense class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    NSDate *currentDate = [NSDate date];
    NSDate *startDate = [currentDate firstMomentInTimeFrame:timeFrame];
    NSDate *endDate = [currentDate lastMomentInTimeFrame:timeFrame];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@ AND dateSpent >= %@ AND dateSpent <= %@", category, startDate, endDate];
    fetchRequest.predicate = predicate;
    
    NSExpressionDescription *totalColumn = [[NSExpressionDescription alloc] init];
    totalColumn.name = @"total";
    totalColumn.expression = [NSExpression expressionWithFormat:@"@sum.amount"];
    totalColumn.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[totalColumn];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateSpent" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
