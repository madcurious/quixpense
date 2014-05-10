//
//  SPRCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryViewController.h"

// Custom views
#import "SPRCategoryHeaderView.h"
#import "SPRCategorySectionHeader.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRExpense+Extension.h"
#import "SPRManagedDocument.h"

// Utilities
#import "SPRIconFont.h"

// View controllers
#import "SPRNewExpenseViewController.h"

static NSString * const kExpenseCell = @"kExpenseCell";
static const NSInteger kDescriptionLabelTag = 1000;
static const NSInteger kAmountLabelTag = 2000;

@interface SPRCategoryViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SPRCategory *category;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableArray *sectionTotals;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    self.category = [SPRCategory allCategories][self.categoryIndex];
    
    SPRCategoryHeaderView *headerView = [[SPRCategoryHeaderView alloc] initWithCategory:self.category];
    self.tableView.tableHeaderView = headerView;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", error);
    }
    
    [self initializeTotals];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupBarButtonItems
{
    UIButton *newExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newExpenseButton setAttributedTitle:[SPRIconFont iconForNewExpense] forState:UIControlStateNormal];
    [newExpenseButton sizeToFit];
    [newExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newExpenseButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem];
}

- (void)initializeTotals
{
    // Initialize _sectionTotals as an empty array of the same size as the number of sections.
    self.sectionTotals = [NSMutableArray array];
    for (int i = 0; i < [[self.fetchedResultsController sections] count]; i++) {
        self.sectionTotals[i] = [NSNull null];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewExpenseModal"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SPRNewExpenseViewController *newExpenseScreen = (SPRNewExpenseViewController *)navigationController.topViewController;
        newExpenseScreen.categoryIndex = self.categoryIndex;
    }
}

#pragma mark - Target actions

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpenseModal" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = [self.fetchedResultsController sections][section];
    return [theSection numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExpenseCell];
    
    SPRExpense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:kDescriptionLabelTag];
    descriptionLabel.text = expense.name;
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:kAmountLabelTag];
    amountLabel.text = [expense.amount currencyString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SPRCategorySectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[section];
    
    NSTimeInterval timeInterval = [[theSection name] doubleValue];
    NSDate *dateSpent = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Total the expenses in a section if they have never been computed yet.
    if (self.sectionTotals[section] == [NSNull null]) {
        NSArray *expenses = [theSection objects];
        SPRExpense *expense = [expenses firstObject];
        NSDecimalNumber *total = expense.amount;
        for (int i = 1; i < expenses.count; i++) {
            expense = expenses[i];
            total = [total decimalNumberByAdding:expense.amount];
        }
        self.sectionTotals[section] = total;
    }
    
    SPRCategorySectionHeader *header = [[SPRCategorySectionHeader alloc] initWithDate:dateSpent total:self.sectionTotals[section]];
    return header;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Fetched results controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self initializeTotals];
    [self.tableView reloadData];
}

#pragma mark - Getters

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SPRExpense" inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", self.category];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateSpent" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:@"dateSpentAsSectionTitle" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
