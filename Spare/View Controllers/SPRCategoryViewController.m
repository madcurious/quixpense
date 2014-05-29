//
//  SPRCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryViewController.h"

// Custom views
#import "SPRCategoryHeaderCell.h"
#import "SPRCategorySectionHeader.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRExpense+Extension.h"
#import "SPRManagedDocument.h"

// Utilities
#import "SPRIconFont.h"

// View controllers
#import "SPRNewExpenseViewController.h"
#import "SPREditExpenseViewController.h"
#import "SPREditCategoryViewController.h"

static NSString * const kCategoryCell = @"kCategoryCell";
static NSString * const kExpenseCell = @"kExpenseCell";

static const NSInteger kDescriptionLabelTag = 1000;
static const NSInteger kAmountLabelTag = 2000;

@interface SPRCategoryViewController () <UITableViewDataSource, UITableViewDelegate,
NSFetchedResultsControllerDelegate,
SPREditCategoryViewControllerDelegate,
UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *noExpensesLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray *sectionTotals;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    [self.tableView registerClass:[SPRCategoryHeaderCell class] forCellReuseIdentifier:kCategoryCell];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", error);
    }
    
    [self initializeTotals];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        CGFloat labelX = [UIScreen mainScreen].bounds.size.width / 2 - self.noExpensesLabel.frame.size.width / 2;
        CGFloat labelY = [self.noExpensesLabel centerYInParent:self.view];
        self.noExpensesLabel.frame = CGRectMake(labelX, labelY, self.noExpensesLabel.frame.size.width, self.noExpensesLabel.frame.size.height);
        [self.view addSubview:self.noExpensesLabel];
    } else {
        [self.tableView reloadData];
    }
}

- (void)setupBarButtonItems
{
    UIButton *newExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newExpenseButton setAttributedTitle:[SPRIconFont addExpenseIcon] forState:UIControlStateNormal];
    [newExpenseButton sizeToFit];
    [newExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newExpenseButton];
    
    UIButton *editCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editCategoryButton setAttributedTitle:[SPRIconFont editIcon] forState:UIControlStateNormal];
    [editCategoryButton sizeToFit];
    [editCategoryButton addTarget:self action:@selector(editCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editCategoryButton];
    
    UIButton *deleteCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteCategoryButton setAttributedTitle:[SPRIconFont deleteIcon] forState:UIControlStateNormal];
    [deleteCategoryButton sizeToFit];
    [deleteCategoryButton addTarget:self action:@selector(deleteCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteCategoryButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem, editCategoryBarButtonItem, deleteCategoryBarButtonItem];
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
        newExpenseScreen.category = self.category;
    }
}

#pragma mark - Target actions

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpenseModal" sender:self];
}

- (void)editCategoryButtonTapped
{
    // Display the edit category modal.
    SPREditCategoryViewController *editCategoryViewController = [[SPREditCategoryViewController alloc] initWithCategory:self.category];
    editCategoryViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editCategoryViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)deleteCategoryButtonTapped
{
    [[[UIAlertView alloc] initWithTitle:@"Confirm delete" message:@"Deleting a category also deletes all its expenses. This cannot be undone. Continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger numberOfSections = 1 + [[self.fetchedResultsController sections] count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        id<NSFetchedResultsSectionInfo> theSection = [self.fetchedResultsController sections][section - 1];
        return [theSection numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        SPRCategoryHeaderCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:kCategoryCell];
        categoryCell.category = self.category;
        cell = categoryCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kExpenseCell];
        
        // Subtract 1 from the indexPath.section because the fetched results controller
        // does not count the category cell as a separate section.
        NSIndexPath *offsetIndexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
        SPRExpense *expense = [self.fetchedResultsController objectAtIndexPath:offsetIndexpath];
        
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:kDescriptionLabelTag];
        descriptionLabel.text = expense.name;
        
        UILabel *amountLabel = (UILabel *)[cell viewWithTag:kAmountLabelTag];
        amountLabel.text = [expense.amount currencyString];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return UITableViewAutomaticDimension;
    }
    
    return SPRCategorySectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The category cell has no header view.
    if (section == 0) {
        return nil;
    }
    
    // Otherwise, the header view should contain a date and total of expenses in the date.
    
    NSInteger offsetSection = section - 1;
    
    id<NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[offsetSection];
    
    NSTimeInterval timeInterval = [[theSection name] doubleValue];
    NSDate *dateSpent = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Total the expenses in a section if they have never been computed yet.
    if (self.sectionTotals[offsetSection] == [NSNull null]) {
        NSArray *expenses = [theSection objects];
        SPRExpense *expense = [expenses firstObject];
        NSDecimalNumber *total = expense.amount;
        for (int i = 1; i < expenses.count; i++) {
            expense = expenses[i];
            total = [total decimalNumberByAdding:expense.amount];
        }
        self.sectionTotals[offsetSection] = total;
    }
    
    SPRCategorySectionHeader *header = [[SPRCategorySectionHeader alloc] initWithDate:dateSpent total:self.sectionTotals[offsetSection]];
    return header;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
        SPRExpense *expense = [self.fetchedResultsController objectAtIndexPath:offsetIndexPath];
        
        SPRManagedDocument *managedDocument = [SPRManagedDocument sharedDocument];
        [managedDocument.managedObjectContext deleteObject:expense];
        [managedDocument saveToURL:managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
    
    SPREditExpenseViewController *editExpenseScreen = [[SPREditExpenseViewController alloc] init];
    editExpenseScreen.expense = [self.fetchedResultsController objectAtIndexPath:offsetIndexPath];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editExpenseScreen];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [SPRCategoryHeaderCell heightForCategory:self.category];
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - Fetched results controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self initializeTotals];
    [self.tableView reloadData];
    
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        [self.noExpensesLabel removeFromSuperview];
    } else {
        CGFloat labelX = [UIScreen mainScreen].bounds.size.width / 2 - self.noExpensesLabel.frame.size.width / 2;
        CGFloat labelY = [self.noExpensesLabel centerYInParent:self.view];
        self.noExpensesLabel.frame = CGRectMake(labelX, labelY, self.noExpensesLabel.frame.size.width, self.noExpensesLabel.frame.size.height);
        [self.view addSubview:self.noExpensesLabel];
    }
}

#pragma mark - Edit category screen delegate

- (void)editCategoryScreen:(SPREditCategoryViewController *)editCategoryScreen didEditCategory:(SPRCategory *)category
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The only alert view in this screen is the Confirm Delete dialog.
    // If one is pressed, the user confirms deleting the category and
    // all the expenses under it.
    if (buttonIndex == 1) {
        [self.category.managedObjectContext deleteObject:self.category];
        
        SPRManagedDocument *managedDocument = [SPRManagedDocument sharedDocument];
        [managedDocument saveToURL:managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - Getters

- (UILabel *)noExpensesLabel
{
    if (_noExpensesLabel) {
        return _noExpensesLabel;
    }
    
    _noExpensesLabel = [[UILabel alloc] init];
    _noExpensesLabel.numberOfLines = 0;
    _noExpensesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noExpensesLabel.textAlignment = NSTextAlignmentCenter;
    
    // Build the NSAttributedString which is to be the label's text.
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor grayColor]};
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"No expenses here yet!\nTap " attributes:textAttributes];
    NSMutableAttributedString *expenseIcon = [[SPRIconFont addExpenseIconDisabled] mutableCopy];
    [expenseIcon addAttribute:NSBaselineOffsetAttributeName value:@(-8) range:NSMakeRange(0, expenseIcon.length)];
    [labelText appendAttributedString:expenseIcon];
    [labelText appendAttributedString:[[NSAttributedString alloc] initWithString:@" to add one." attributes:textAttributes]];
    
    _noExpensesLabel.attributedText = labelText;
    [_noExpensesLabel sizeToFitWidth:300];
    
    return _noExpensesLabel;
}

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
