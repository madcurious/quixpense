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
#import "SPRExpenseSectionHeaderView.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRExpense+Extension.h"
#import "SPRManagedDocument.h"
#import "SPRExpenseSection.h"

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

@property (strong, nonatomic) NSMutableArray *expenses;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backButton = self.navigationItem.leftBarButtonItem;
    [self setupBarButtonItems];
    [self.tableView registerClass:[SPRCategoryHeaderCell class] forCellReuseIdentifier:kCategoryCell];
//    [self initializeTotals];
    [self performFetch];
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
    
//    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [moveButton setAttributedTitle:[SPRIconFont moveIcon] forState:UIControlStateNormal];
//    [moveButton sizeToFit];
//    [moveButton addTarget:self action:@selector(moveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *moveBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moveButton];
    
    UIButton *deleteCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteCategoryButton setAttributedTitle:[SPRIconFont deleteIcon] forState:UIControlStateNormal];
    [deleteCategoryButton sizeToFit];
    [deleteCategoryButton addTarget:self action:@selector(deleteCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteCategoryButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem, editBarButtonItem, deleteCategoryBarButtonItem];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)showEditCategoryModal
{
    SPREditCategoryViewController *editCategoryViewController = [[SPREditCategoryViewController alloc] initWithCategory:self.category];
    editCategoryViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editCategoryViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (SPRExpense *)expenseAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *expensesInSection = self.expenses[indexPath.section];
    SPRExpense *expense = expensesInSection[indexPath.row];
    return expense;
}

- (void)performFetch
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", error);
    }
    
    // Initialize the arrays
    self.sections = [NSMutableArray array];
    self.expenses = [NSMutableArray array];
    
    id<NSFetchedResultsSectionInfo> sectionInfo;
    NSDate *dateSpent;
    SPRExpenseSection *section;
    SPRExpense *expense;
    NSMutableArray *expenses;
    
    // Create the sections.
    for (int i = 0; i < self.fetchedResultsController.sections.count; i++) {
        sectionInfo = self.fetchedResultsController.sections[i];
        NSTimeInterval timeInterval = [[sectionInfo name] doubleValue];
        dateSpent = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        section = [[SPRExpenseSection alloc] initWithDate:dateSpent];
        [self.sections addObject:section];
        
        // Create the expenses.
        expenses = [NSMutableArray array];
        for (int j = 0; j < [sectionInfo numberOfObjects]; j++) {
            expense = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [expenses addObject:expense];
        }
        [self.expenses addObject:expenses];
    }
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
        SPRExpense *expense = [self expenseAtIndexPath:[indexPath indexPathByOffsettingSection:-1]];
        
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
    
    NSUInteger offsetSection = section - 1;
    SPRExpenseSection *sectionInfo = self.sections[offsetSection];
    
    // If the total has not yet been computed, compute for it.
    if (sectionInfo.total == nil) {
        NSMutableArray *expenses = self.expenses[offsetSection];
        sectionInfo.total = [expenses valueForKeyPath:@"@sum.amount"];
    }
    
    SPRExpenseSectionHeaderView *header = [[SPRExpenseSectionHeaderView alloc] initWithDate:sectionInfo.date total:sectionInfo.total];
    return header;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SPRExpense *expense = [self expenseAtIndexPath:[indexPath indexPathByOffsettingSection:-1]];
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
    
    NSIndexPath *offsetIndexPath = [indexPath indexPathByOffsettingSection:-1];
    
    SPREditExpenseViewController *editExpenseScreen = [[SPREditExpenseViewController alloc] init];
    editExpenseScreen.expense = [self expenseAtIndexPath:offsetIndexPath];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editExpenseScreen];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Prepare the needed variables.
    
    NSIndexPath *offsetSourceIndexPath = [sourceIndexPath indexPathByOffsettingSection:-1];
    NSIndexPath *offsetDestinationIndexPath = [destinationIndexPath indexPathByOffsettingSection:-1];
    
    SPRExpenseSection *sourceSection = self.sections[offsetSourceIndexPath.section];
    NSDate *sourceDate = sourceSection.date;
    SPRExpenseSection *destinationSection = self.sections[offsetDestinationIndexPath.section];
    NSDate *destinationDate = destinationSection.date;
    
    SPRExpense *expense = [self expenseAtIndexPath:offsetSourceIndexPath];
    
    // Set the expense's date to destination section's date.
    
    expense.dateSpent = destinationDate;
    
    // If the row is the topmost, make the display order higher than all the others.
    
    if (offsetDestinationIndexPath.row == 0) {
        SPRExpense *currentTop = [self expenseAtIndexPath:offsetDestinationIndexPath];
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
            NSIndexPath *topIndexPath = [offsetDestinationIndexPath indexPathByOffsettingRow:-1];
            SPRExpense *topExpense = [self expenseAtIndexPath:topIndexPath];
            double topExpenseDisplayOrder = [topExpense.displayOrder doubleValue];
            
//            NSIndexPath *bottomIndexPath = [offsetDestinationIndexPath indexPathByOffsettingRow:1];
            NSIndexPath *bottomIndexPath = offsetDestinationIndexPath;
            SPRExpense *bottomExpense = [self expenseAtIndexPath:bottomIndexPath];
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeMove) {
        return;
    }
    
    [self performFetch];
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
