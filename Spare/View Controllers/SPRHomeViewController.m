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

typedef NS_ENUM(NSUInteger, SPRTotalTimeFrame) {
    SPRTotalTimeFrameDay = 0,
    SPRTotalTimeFrameWeek = 1,
    SPRTotalTimeFrameMonth,
    SPRTotalTimeFrameYear,
};

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface SPRHomeViewController () <LXReorderableCollectionViewDataSource, UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SPRStatusView *statusView;

@property (nonatomic) NSInteger selectedCategoryIndex;

@property (nonatomic) BOOL hasBeenSetup;

@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;
@property (strong, nonatomic) NSFetchedResultsController *dailyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *weeklyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *monthlyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *yearlyTotalFetcher;
@property (nonatomic) NSInteger activeTotalFetcher;
@property (strong, nonatomic) NSArray *totalFetchers;

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
    
    self.totalFetchers = @[self.categoryFetcher];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasBeenSetup) {
        NSError *error;
        if (![self.categoryFetcher performFetch:&error]) {
            NSLog(@"%@", error);
        }
        if (![self.dailyTotalFetcher performFetch:&error]) {
            NSLog(@"%@", error);
        }
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

#pragma mark - Target actions

- (void)newCategoryButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewCategoryModal" sender:self];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.categoryFetcher fetchedObjects] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Get the category at the index path.
    SPRCategory *category = [self.categoryFetcher fetchedObjects][indexPath.row];
    
    cell.category = category;
    
    if (indexPath.row < [[self.dailyTotalFetcher fetchedObjects] count]) {
        NSDictionary *categoryTotal = [self.dailyTotalFetcher fetchedObjects][indexPath.row];
        cell.displayedTotal = categoryTotal[@"total"];
    } else {
        cell.displayedTotal = [[NSDecimalNumber alloc] initWithInt:0];
    }
    
    return cell;
}

#pragma mark - LXReorderableCollectionView data source

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *categories = [[self.categoryFetcher fetchedObjects] mutableCopy];
    SPRCategory *category = categories[fromIndexPath.row];
    [categories removeObject:category];
    [categories insertObject:category atIndex:toIndexPath.row];
    
    for (int i = 0; i < categories.count; i++) {
        category = categories[i];
        category.displayOrder = @(i);
    }
    
    // Persist the reordering into the managed document.
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        NSError *error;
        if (![self.dailyTotalFetcher performFetch:&error]) {
            NSLog(@"%@", error);
        }
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

- (NSFetchedResultsController *)dailyTotalFetcher
{
    if (_dailyTotalFetcher) {
        return _dailyTotalFetcher;
    }
    
    _dailyTotalFetcher = [SPRHomeViewController totalFetcherForTimeFrame:SPRTotalTimeFrameDay];
    
    return _dailyTotalFetcher;
}

+ (NSFetchedResultsController *)totalFetcherForTimeFrame:(SPRTotalTimeFrame)timeFrame
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRExpense class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit fromDate:currentDate];
    
    NSDate *startDate, *endDate;
    switch (timeFrame) {
        case SPRTotalTimeFrameDay: {
            NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
            startDateComponents.month = currentDateComponents.month;
            startDateComponents.day = currentDateComponents.day;
            startDateComponents.year = currentDateComponents.year;
            startDateComponents.hour = 0;
            startDateComponents.minute = 0;
            startDateComponents.second = 0;
            startDate = [calendar dateFromComponents:startDateComponents];
            
            NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
            endDateComponents.month = currentDateComponents.month;
            endDateComponents.day = currentDateComponents.day;
            endDateComponents.year = currentDateComponents.year;
            endDateComponents.hour = 23;
            endDateComponents.minute = 59;
            endDateComponents.second = 59;
            endDate = [calendar dateFromComponents:endDateComponents];
            break;
        }
        case SPRTotalTimeFrameWeek: {
            break;
        }
        case SPRTotalTimeFrameMonth: {
            break;
        }
        case SPRTotalTimeFrameYear: {
            break;
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateSpent >= %@ AND dateSpent <= %@", startDate, endDate];
    fetchRequest.predicate = predicate;
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"total";
    expressionDescription.expression = [NSExpression expressionWithFormat:@"@sum.amount"];
    expressionDescription.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[expressionDescription];
    fetchRequest.propertiesToGroupBy = @[@"category"];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.displayOrder" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
