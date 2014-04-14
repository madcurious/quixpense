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
        if (error) {
            NSLog(@"%@", error);
        }
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewExpense"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SPRNewExpenseViewController *newExpenseScreen = (SPRNewExpenseViewController *)navigationController.topViewController;
        newExpenseScreen.categoryIndex = self.categoryIndex;
    }
}

#pragma mark - Target actions

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpense" sender:self];
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
    amountLabel.text = expense.amountAsString;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[section];
    
    NSTimeInterval timeInterval = [[theSection name] doubleValue];
    NSDate *dateSpent = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    static NSDateFormatter *sectionDateFormatter = nil;
    
    if (!sectionDateFormatter) {
        sectionDateFormatter = [[NSDateFormatter alloc] init];
        sectionDateFormatter.calendar = [NSCalendar currentCalendar];
        sectionDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    NSString *sectionTitle = [sectionDateFormatter stringFromDate:dateSpent];
    
    return sectionTitle;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
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
