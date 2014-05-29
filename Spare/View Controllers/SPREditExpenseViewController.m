//
//  SPREditExpenseViewController.m
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPREditExpenseViewController.h"

// Custom views
#import "SPRExpenseDescriptionCell.h"
#import "SPRExpenseAmountCell.h"
#import "SPRExpenseCategoryCell.h"
#import "SPRExpenseDateSpentCell.h"
#import "SPRCategoryPicker.h"
#import "SPRDatePicker.h"

// Objects
#import "SPRField.h"
#import "SPRExpense.h"
#import "SPRManagedDocument.h"

static NSString * const kDescriptionCell = @"kDescriptionCell";
static NSString * const kAmountCell = @"kAmountCell";
static NSString * const kCategoryCell = @"kCategoryCell";
static NSString * const kDateSpentCell = @"kDateSpentCell";
static NSString * const kDeleteCell = @"kDeleteCell";

static const NSInteger kConfirmDeleteAlertViewTag = 1000;

typedef NS_ENUM(NSUInteger, kRow)
{
    kRowDescription = 0,
    kRowAmount = 1,
    kRowCategory,
    kRowDateSpent,
};

@interface SPREditExpenseViewController () <SPRCategoryPickerDelegate, SPRDatePickerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *cellIdentifiers;
@property (strong, nonatomic) NSArray *fields;

@end

@implementation SPREditExpenseViewController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = @"Edit Expense";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register table view cell classes.
    [self.tableView registerClass:[SPRExpenseDescriptionCell class] forCellReuseIdentifier:kDescriptionCell];
    [self.tableView registerClass:[SPRExpenseAmountCell class] forCellReuseIdentifier:kAmountCell];
    [self.tableView registerClass:[SPRExpenseCategoryCell class] forCellReuseIdentifier:kCategoryCell];
    [self.tableView registerClass:[SPRExpenseDateSpentCell class] forCellReuseIdentifier:kDateSpentCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDeleteCell];
    
    // Set up the bar button items.
    [self setupBarButtonItems];
    
    self.cellIdentifiers = @[kDescriptionCell, kAmountCell, kCategoryCell, kDateSpentCell];
    
    self.fields = @[[[SPRField alloc] initWithValue:self.expense.name],
                    [[SPRField alloc] initWithValue:self.expense.amount],
                    [[SPRField alloc] initWithValue:self.expense.category],
                    [[SPRField alloc] initWithValue:self.expense.dateSpent]];
}

#pragma mark - Helper methods

- (void)setupBarButtonItems
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Target actions

- (void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped
{
    // First, check if any of the fields are missing.
    
    NSString *name = [((SPRField *)self.fields[kRowDescription]).value trim];
    NSString *amount = [((SPRField *)self.fields[kRowAmount]).value trim];
    SPRCategory *category = ((SPRField *)self.fields[kRowCategory]).value;
    
    NSMutableArray *missingFields = [NSMutableArray array];
    if (name.length == 0) {
        [missingFields addObject:@"Name"];
    }
    if (amount.length == 0) {
        [missingFields addObject:@"Amount"];
    }
    if (category == nil) {
        [missingFields addObject:@"Category"];
    }
    
    // If there are missing fields, display a dialog.
    if (missingFields.count > 0) {
        NSString *message = [NSString stringWithFormat:@"You must enter the following:\n%@", [missingFields componentsJoinedByString:@", "]];
        [[[UIAlertView alloc] initWithTitle:@"Missing fields" message:message delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil] show];
        return;
    }
    
    self.expense.name = name;
    self.expense.amount = [NSDecimalNumber decimalNumberWithString:amount];
    self.expense.category = category;
    self.expense.dateSpent = ((SPRField *)self.fields[kRowDateSpent]).value;
    
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    __weak SPREditExpenseViewController *weakSelf = self;
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        SPREditExpenseViewController *innerSelf = weakSelf;
        [innerSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.cellIdentifiers.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *identifier = self.cellIdentifiers[indexPath.row];
        SPRFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.field = self.fields[indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDeleteCell];
    cell.textLabel.text = @"Delete Expense";
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If this is the Delete cell section.
    if (indexPath.section == 1) {
        UIAlertView *confirmDialog = [[UIAlertView alloc] initWithTitle:@"Confirm action" message:@"This can't be undone. Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        confirmDialog.tag = kConfirmDeleteAlertViewTag;
        [confirmDialog show];
        return;
    }
    
    switch (indexPath.row) {
        case kRowCategory: {
            SPRCategoryPicker *categoryPicker = [[SPRCategoryPicker alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
            categoryPicker.delegate = self;
            categoryPicker.preselectedCategory = self.expense.category;
            [self.navigationController.view addSubview:categoryPicker];
            [categoryPicker show];
            break;
        }
        case kRowDateSpent: {
            SPRDatePicker *datePicker = [[SPRDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
            datePicker.delegate = self;
            datePicker.preselectedDate = ((SPRField *)self.fields[kRowDateSpent]).value;
            [self.navigationController.view addSubview:datePicker];
            [datePicker show];
            break;
        }
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kConfirmDeleteAlertViewTag: {
            // First, deselect the Delete Expense cell.
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
            
            // If the user confirms deleting the expense...
            if (buttonIndex == 1) {
                SPRManagedDocument *managedDocument = [SPRManagedDocument sharedDocument];
                [managedDocument.managedObjectContext deleteObject:self.expense];
                [managedDocument saveToURL:managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            break;
        }
    }
}

#pragma mark - Category picker delegate

- (void)categoryPicker:(SPRCategoryPicker *)categoryPicker didSelectCategory:(SPRCategory *)category
{
    SPRField *categoryField = self.fields[kRowCategory];
    categoryField.value = category;
    
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:kRowCategory inSection:0];
    
    // Reload the category cell to display the name of the selection.
    [self.tableView reloadRowsAtIndexPaths:@[categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Keep the category cell selected.
    [self.tableView selectRowAtIndexPath:categoryIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)categoryPickerWillDisappear:(SPRCategoryPicker *)categoryPicker
{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:kRowCategory inSection:0] animated:YES];
}

#pragma mark - Date picker delegate

- (void)datePicker:(SPRDatePicker *)datePicker didSelectDate:(NSDate *)date
{
    SPRField *dateSpentField = self.fields[kRowDateSpent];
    dateSpentField.value = date;
    
    NSIndexPath *dateSpentIndexPath = [NSIndexPath indexPathForRow:kRowDateSpent inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[dateSpentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:dateSpentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)datePickerWillDisappear:(SPRDatePicker *)datePicker
{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:kRowDateSpent inSection:0] animated:YES];
}

@end
