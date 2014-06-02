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
@property (strong, nonatomic) UIBarButtonItem *backButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray *sectionTotals;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backButton = self.navigationItem.leftBarButtonItem;
    [self setupBarButtonItems];
    [self.tableView registerClass:[SPRCategoryHeaderCell class] forCellReuseIdentifier:kCategoryCell];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewExpenseModal"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SPRNewExpenseViewController *newExpenseScreen = (SPRNewExpenseViewController *)navigationController.topViewController;
        newExpenseScreen.category = self.category;
    }
}

#pragma mark - Helper methods

- (void)deleteCategory
{
    [self.category.managedObjectContext deleteObject:self.category];
    
    SPRManagedDocument *managedDocument = [SPRManagedDocument sharedDocument];
    [managedDocument saveToURL:managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initializeTotals
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", error);
    }
    
    // Initialize _sectionTotals as an empty array of the same size as the number of sections.
    self.sectionTotals = [NSMutableArray array];
    for (int i = 0; i < [[self.fetchedResultsController sections] count]; i++) {
        self.sectionTotals[i] = [NSNull null];
    }
}

- (void)setupBarButtonItems
{
    UIButton *newExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newExpenseButton setAttributedTitle:[SPRIconFont addExpenseIcon] forState:UIControlStateNormal];
    [newExpenseButton sizeToFit];
    [newExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newExpenseButton];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setAttributedTitle:[SPRIconFont editIcon] forState:UIControlStateNormal];
    [editButton sizeToFit];
    [editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [moveButton setAttributedTitle:[SPRIconFont moveIcon] forState:UIControlStateNormal];
    [moveButton sizeToFit];
    [moveButton addTarget:self action:@selector(moveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moveBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moveButton];
    
    UIButton *deleteCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteCategoryButton setAttributedTitle:[SPRIconFont deleteIcon] forState:UIControlStateNormal];
    [deleteCategoryButton sizeToFit];
    [deleteCategoryButton addTarget:self action:@selector(deleteCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteCategoryButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem, editBarButtonItem, moveBarButtonItem, deleteCategoryBarButtonItem];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)showEditCategoryModal
{
    SPREditCategoryViewController *editCategoryViewController = [[SPREditCategoryViewController alloc] initWithCategory:self.category];
    editCategoryViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editCategoryViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (NSDate *)dateForHeaderInSection:(NSUInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[section];
    NSTimeInterval timeInterval = [[theSection name] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

#pragma mark - Target actions

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpenseModal" sender:self];
}

- (void)editButtonTapped
{
    [self showEditCategoryModal];
}

- (void)moveButtonTapped
{
    self.tableView.allowsSelection = NO;
    
    self.title = @"Move";
    
    // Set editing to no before setting it to yes, so that any currently showing
    // Delete buttons in a left-swiped table view cell are hidden.
    self.tableView.editing = NO;
    [self.tableView setEditing:YES animated:YES];
    
    // Hide the Back button.
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *cancelMovingBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMovingButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelMovingBarButtonItem;
    
    UIBarButtonItem *doneMovingBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneMovingButtonTapped)];
    self.navigationItem.rightBarButtonItems = @[doneMovingBarButtonItem];
}

- (void)cancelMovingButtonTapped
{
    [self.category.managedObjectContext rollback];
    [self.tableView reloadData];
    
    self.tableView.allowsSelection = YES;
    self.title = nil;
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.hidesBackButton = NO;
    [self setupBarButtonItems];
}

- (void)doneMovingButtonTapped
{
    // Save the changes.
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
    
    self.tableView.allowsSelection = YES;
    self.title = nil;
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.hidesBackButton = NO;
    [self setupBarButtonItems];
}

- (void)deleteCategoryButtonTapped
{
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        [[[UIAlertView alloc] initWithTitle:@"Confirm delete" message:@"Deleting a category also deletes all its expenses. This cannot be undone. Continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
        return;
    } else {
        [self deleteCategory];
    }
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
        return [self.fetchedResultsController numberOfObjectsInSection:section - 1];
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
    NSDate *dateSpent = [self dateForHeaderInSection:offsetSection];
    
    // Total the expenses in a section if they have never been computed yet.
    id<NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[offsetSection];
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleNone;
    } else {
        if (indexPath.section > 0) {
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // Display the edit category modal.
        [self showEditCategoryModal];
        return;
    }
    
    NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
    
    SPREditExpenseViewController *editExpenseScreen = [[SPREditExpenseViewController alloc] init];
    editExpenseScreen.expense = [self.fetchedResultsController objectAtIndexPath:offsetIndexPath];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editExpenseScreen];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSIndexPath *offsetSourceIndexPath = [sourceIndexPath indexPathByOffsettingSection:-1];
    SPRExpense *expense = [self.fetchedResultsController objectAtIndexPath:offsetSourceIndexPath];
    
    // Set the expense's date to the date in section of destination index path.
    NSDate *sourceDate = [self dateForHeaderInSection:offsetSourceIndexPath.section];
    NSDate *destinationDate = [self dateForHeaderInSection:(destinationIndexPath.section - 1)];
    expense.dateSpent = destinationDate;
    
    // Prepare to set the display order.
    NSIndexPath *offsetDestinationIndexPath = [destinationIndexPath indexPathByOffsettingSection:-1];
    
    // If the row is the topmost, make the display order higher than all the others.
    if (offsetDestinationIndexPath.row == 0) {
        SPRExpense *currentTop = [self.fetchedResultsController objectAtIndexPath:offsetDestinationIndexPath];
        double newDisplayOrder = [currentTop.displayOrder doubleValue] + 1;
        expense.displayOrder = @(newDisplayOrder);
    }
    
    // If the expense is being moved to the bottommost of the section,
    // make the display order lower than all others.
    else {
        NSUInteger rowCount = [self.fetchedResultsController numberOfObjectsInSection:offsetDestinationIndexPath.section];
        BOOL movingToBottom;
        if ([sourceDate isSameDayAsDate:destinationDate]) {
            movingToBottom = offsetDestinationIndexPath.row == rowCount - 1;
        } else {
            movingToBottom = offsetDestinationIndexPath.row == rowCount;
        }
        
        if (movingToBottom) {
            SPRExpense *currentBottom = [self.fetchedResultsController lastObjectInSection:offsetDestinationIndexPath.section];
            double newDisplayOrder = [currentBottom.displayOrder doubleValue] - 1;
            expense.displayOrder = @(newDisplayOrder);
        }
        
        // If put between two expenses, set the display order to be
        // a number between the display orders of the two expenses.
        else {
            NSIndexPath *topIndexPath = offsetDestinationIndexPath;
            SPRExpense *topExpense = [self.fetchedResultsController objectAtIndexPath:topIndexPath];
            double topExpenseDisplayOrder = [topExpense.displayOrder doubleValue];
            
            NSIndexPath *bottomIndexPath = [offsetDestinationIndexPath indexPathByOffsettingRow:1];
            SPRExpense *bottomExpense = [self.fetchedResultsController objectAtIndexPath:bottomIndexPath];
            double bottomExpenseDisplayOrder = [bottomExpense.displayOrder doubleValue];
            
            double newDisplayOrder = bottomExpenseDisplayOrder + (topExpenseDisplayOrder - bottomExpenseDisplayOrder) / 2;
            expense.displayOrder = [NSNumber numberWithDouble:newDisplayOrder];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // If the cell was dragged to where the colored category cell is,
    // put it on the first row of the first section of expenses.
    NSIndexPath *destinationIndexPath;
    if (proposedDestinationIndexPath.section == 0) {
        destinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    } else {
        destinationIndexPath = proposedDestinationIndexPath;
    }
    return destinationIndexPath;
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
        [self deleteCategory];
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
    
    // First, sort the expenses by most recent dateSpent so that sections are also sorted by most recent.
    // Next, sort the expenses according to displayOrder.
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"dateSpent" ascending:NO],
                                     [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:NO]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:@"dateSpentAsSectionTitle" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
