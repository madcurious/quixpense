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
#import "SPRCategoryCollectionViewCell.h"

// View controllers
#import "SPRNewCategoryViewController.h"
#import "SPRCategoryViewController.h"
#import "SPRNewExpenseViewController.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRManagedDocument.h"
#import "SPRExpense.h"
#import "SPRCategorySummary.h"

// Pods
#import "UICollectionView+Draggable.h"

// Constants
#import "SPRTimeFrame.h"

// Categories
#import "UIColor+HexColor.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface SPRHomeViewController () <UICollectionViewDataSource_Draggable,
UICollectionViewDelegate,
NSFetchedResultsControllerDelegate,
SPRNewExpenseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *noCategoriesLabel;
@property (strong, nonatomic) UIButton *addExpenseButton;
@property (strong, nonatomic) UILabel *totalLabel;

@property (nonatomic) NSInteger selectedCategoryIndex;
@property (nonatomic) BOOL hasBeenSetup;

@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;
@property (strong, nonatomic) NSMutableArray *summaries;
@property (nonatomic) SPRTimeFrame activeTimeFrame;

@end

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the bar button item.s
    [self setupBarButtonItems];
    
    self.collectionView.draggable = YES;
    // Register a collection view cell class.
    [self.collectionView registerClass:[SPRCategoryCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    // By default, the active time frame for totals is daily.
    self.activeTimeFrame = SPRTimeFrameDay;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasBeenSetup) {
        [self initializeSummaries];
        [self updateTotalLabel];
        
        // If there are no categories yet...
        if (self.categoryFetcher.fetchedObjects.count == 0) {
            // Disable the add expenses button.
            self.addExpenseButton.enabled = NO;
            
            // Display a none-yet label.
            CGFloat labelX = [UIScreen mainScreen].bounds.size.width / 2 - self.noCategoriesLabel.frame.size.width / 2;
            CGFloat labelY = [self.noCategoriesLabel centerYInParent:self.view];
            self.noCategoriesLabel.frame = CGRectMake(labelX, labelY, self.noCategoriesLabel.frame.size.width, self.noCategoriesLabel.frame.size.height);
            [self.view addSubview:self.noCategoriesLabel];
        }
        
        // Otherwise, enable the add expense button and reload the collection view.
        else {
            self.addExpenseButton.enabled = YES;
            [self.collectionView reloadData];
        }
    }
    
    // If the screen has not been set up yet, display a loading modal.
    else {
        [self performSegueWithIdentifier:@"presentSetup" sender:self];
        self.hasBeenSetup = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushCategory"]) {
        SPRCategoryViewController *categoryScreen = segue.destinationViewController;
        SPRCategorySummary *summary = self.summaries[self.selectedCategoryIndex];
        categoryScreen.category = summary.category;
        return;
    }
    
    else if ([segue.identifier isEqualToString:@"presentNewExpenseModal"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SPRNewExpenseViewController *newExpenseScreen = navigationController.viewControllers[0];
        newExpenseScreen.delegate = self;
        return;
    }
}

#pragma mark - Helper methods

- (void)setupBarButtonItems
{
    // The total label.
    UIBarButtonItem *totalLabelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.totalLabel];
    self.navigationItem.leftBarButtonItem = totalLabelBarButtonItem;
    
    // The new category button.
    UIButton *newCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newCategoryButton setAttributedTitle:[SPRIconFont addCategoryIcon] forState:UIControlStateNormal];
    [newCategoryButton sizeToFit];
    [newCategoryButton addTarget:self action:@selector(newCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCategoryButton];
    
    // The new expense button.
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addExpenseButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem, newCategoryBarButtonItem];
}

- (void)initializeSummaries
{
    self.summaries = [NSMutableArray array];
    
    NSError *error;
    [self.categoryFetcher performFetch:&error];
    if (error) {
        NSLog(@"Error fetching categories: %@", error);
    }
    
    for (SPRCategory *category in self.categoryFetcher.fetchedObjects) {
        [self.summaries addObject:[[SPRCategorySummary alloc] initWithCategory:category]];
    }
}

- (void)updateTotalLabel
{
    // Sum all the active totals and set it as the total label's text.
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *singleTotal;
    
    for (SPRCategorySummary *summary in self.summaries) {
        singleTotal = [summary totalForTimeFrame:self.activeTimeFrame];
        total = [total decimalNumberByAdding:singleTotal];
    }
    
    self.totalLabel.text = [total currencyString];
    [self.totalLabel sizeToFit];
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
    
    [self updateTotalLabel];
    
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.summaries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SPRCategorySummary *summary = self.summaries[indexPath.row];
    cell.category = summary.category;
    cell.displayedTotal = [summary totalForTimeFrame:self.activeTimeFrame];
    
    return cell;
}

#pragma mark - Draggable collection view data source

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Move the summary's location in the array.
    SPRCategorySummary *summary = self.summaries[fromIndexPath.row];
    [self.summaries removeObject:summary];
    [self.summaries insertObject:summary atIndex:toIndexPath.row];
    
    // Reassign the display order of categories.
    for (int i = 0; i < self.summaries.count; i++) {
        summary = self.summaries[i];
        summary.category.displayOrder = @(i);
    }
    
    // Persist the reordering into the managed document.
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGAffineTransform)collectionView:(UICollectionView *)collectionView transformForDraggingItemAtIndexPath:(NSIndexPath *)indexPath duration:(NSTimeInterval *)duration
{
    return CGAffineTransformMakeScale(1.15, 1.15);
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCategoryIndex = indexPath.row;
    [self performSegueWithIdentifier:@"pushCategory" sender:self];
}

#pragma mark - Fetched results controller delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (controller != self.categoryFetcher) {
        return;
    }
    
    if (self.categoryFetcher.fetchedObjects.count > 0) {
        [self.noCategoriesLabel removeFromSuperview];
    } else {
        [self.collectionView reloadData];
    }
}

#pragma mark - New expense screen delegate

- (void)newExpenseScreenDidAddExpense:(SPRExpense *)expense
{
    // Fetch all the expenses with the same dateSpent sorted by displayOrder.
    // Avoid fetching the newly created expense.
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRExpense class]) inManagedObjectContext:expense.managedObjectContext];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"category == %@ AND dateSpent == %@ AND self != %@", expense.category, expense.dateSpent, expense];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
    
    NSError *error;
    NSMutableArray *expenses = [[expense.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"%@", error);
    }
    
    // Then, set their displayOrder values from 1 onwards.
    
    if (expenses.count > 0) {
        SPRExpense *currentExpense;
        for (int i = 0; i < expenses.count; i++) {
            currentExpense = expenses[i];
            currentExpense.displayOrder = @(i + 1);
        }
        
        // Save the changes.
        [[SPRManagedDocument sharedDocument] saveWithCompletionHandler:nil];
    }
}

#pragma mark - Getters

- (UILabel *)noCategoriesLabel
{
    if (_noCategoriesLabel) {
        return _noCategoriesLabel;
    }
    
    _noCategoriesLabel = [[UILabel alloc] init];
    _noCategoriesLabel.numberOfLines = 0;
    _noCategoriesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noCategoriesLabel.textAlignment = NSTextAlignmentCenter;
    
    // Build the NSAttributedString which is to be the label's text.
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor grayColor]};
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"You have no categories yet!\nTap " attributes:textAttributes];
    [labelText appendAttributedString:[SPRIconFont addCategoryIconDisabled]];
    [labelText appendAttributedString:[[NSAttributedString alloc] initWithString:@" to add one." attributes:textAttributes]];
    
    _noCategoriesLabel.attributedText = labelText;
    [_noCategoriesLabel sizeToFitWidth:300];
    
    return _noCategoriesLabel;
}

- (UILabel *)totalLabel
{
    if (_totalLabel) {
        return _totalLabel;
    }
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.numberOfLines = 1;
    _totalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _totalLabel.font = [UIFont systemFontOfSize:18];
    _totalLabel.textColor = [UIColor colorFromHex:0x007aff];
    return _totalLabel;
}

- (UIButton *)addExpenseButton
{
    if (_addExpenseButton) {
        return _addExpenseButton;
    }
    
    _addExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addExpenseButton setAttributedTitle:[SPRIconFont addExpenseIcon] forState:UIControlStateNormal];
    [_addExpenseButton setAttributedTitle:[SPRIconFont addExpenseIconDisabled] forState:UIControlStateDisabled];
    [_addExpenseButton sizeToFit];
    [_addExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    return _addExpenseButton;
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

@end
