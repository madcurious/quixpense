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

// Utilities
#import "SPRIconFont.h"

// View controllers
#import "SPRNewExpenseViewController.h"

static NSString * const kExpenseCell = @"kExpenseCell";
static const NSInteger kDescriptionLabelTag = 1000;
static const NSInteger kAmountLabelTag = 2000;

@interface SPRCategoryViewController () <UITableViewDataSource, UITableViewDelegate, SPRNewExpenseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SPRCategory *category;
@property (strong, nonatomic) NSArray *expenses;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    self.category = [SPRCategory allCategories][self.categoryIndex];
    
    SPRCategoryHeaderView *headerView = [[SPRCategoryHeaderView alloc] initWithCategory:self.category];
    self.tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.expenses == nil) {
        [self loadExpenses];
    }
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

- (void)loadExpenses
{
    self.expenses = self.category.expenses.allObjects;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewExpense"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SPRNewExpenseViewController *newExpenseScreen = (SPRNewExpenseViewController *)navigationController.topViewController;
        newExpenseScreen.categoryIndex = self.categoryIndex;
        newExpenseScreen.delegate = self;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExpenseCell];
    
    SPRExpense *expense = self.expenses[indexPath.row];
    
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:kDescriptionLabelTag];
    descriptionLabel.text = expense.name;
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:kAmountLabelTag];
    amountLabel.text = expense.amountAsString;
    
    return cell;
}

#pragma mark - New expense screen delegate

- (void)newExpenseViewControllerDidAddExpense
{
    self.expenses = nil;
    [self loadExpenses];
}

@end
