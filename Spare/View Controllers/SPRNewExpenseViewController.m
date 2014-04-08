//
//  SPRNewExpenseViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRNewExpenseViewController.h"

// Objects
#import "SPRField.h"
#import "SPRCategory+Extension.h"
#import "SPRManagedDocument.h"
#import "SPRExpense.h"

// Custom views
#import "SPRTextField.h"
#import "SPRCategoryPickerView.h"

typedef NS_ENUM(NSInteger, kRow)
{
    kRowDescription = 0,
    kRowAmount = 1,
    kRowCategory,
    kRowDateSpent,
};

static NSString * const kDescriptionCell = @"kDescriptionCell";
static NSString * const kAmountCell = @"kAmountCell";
static NSString * const kCategoryCell = @"kCategoryCell";
static NSString * const kDateSpentCell = @"kDateSpentCell";

static const NSInteger kTextFieldTag = 1000;

@interface SPRNewExpenseViewController () <UITextFieldDelegate, SPRCategoryPickerViewDelegate>

@property (strong, nonatomic) NSArray *identifiers;
@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) SPRCategory *category;

@end

@implementation SPRNewExpenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.identifiers = @[kDescriptionCell, kAmountCell, kCategoryCell, kDateSpentCell];
    
    self.category = [SPRCategory allCategories][self.categoryIndex];
    
    self.fields = @[[[SPRField alloc] initWithName:@"Description"],
                    [[SPRField alloc] initWithName:@"Amount"],
                    [[SPRField alloc] initWithName:@"Category" value:self.category],
                    [[SPRField alloc] initWithName:@"Date spent" value:[NSDate date]]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender
{
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    
    SPRExpense *expense = [NSEntityDescription insertNewObjectForEntityForName:@"SPRExpense" inManagedObjectContext:self.category.managedObjectContext];
    expense.name = ((SPRField *)self.fields[kRowDescription]).value;
    expense.amount = [NSDecimalNumber decimalNumberWithString:((SPRField *)self.fields[kRowAmount]).value];
    expense.category = ((SPRField *)self.fields[kRowCategory]).value;
    expense.dateSpent = ((SPRField *)self.fields[kRowDateSpent]).value;
    
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if ([self.delegate respondsToSelector:@selector(newExpenseViewControllerDidAddExpense)]) {
            [self.delegate newExpenseViewControllerDidAddExpense];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.identifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.identifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    SPRField *field = self.fields[indexPath.row];
    
    switch (indexPath.row) {
        case kRowDescription:
        case kRowAmount: {
            SPRTextField *textField = (SPRTextField *)[cell viewWithTag:kTextFieldTag];
            textField.field = field;
            textField.text = (NSString *)field.value;
            textField.delegate = self;
            break;
        }
        case kRowCategory: {
            SPRCategory *selectedCategory = field.value;
            if (selectedCategory) {
                cell.detailTextLabel.text = selectedCategory.name;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            break;
        }
        case kRowDateSpent: {
            NSDate *date = (NSDate *)field.value;
            cell.detailTextLabel.text = [date textInForm];
            break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kRowCategory: {
            SPRCategoryPickerView *categoryPicker = [[SPRCategoryPickerView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
            categoryPicker.delegate = self;
            categoryPicker.preselectedRow = self.categoryIndex;
            [self.navigationController.view addSubview:categoryPicker];
            [categoryPicker show];
            break;
        }
    }
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SPRTextField *theTextField = (SPRTextField *)textField;
    SPRField *field = theTextField.field;
    
    if (field == self.fields[kRowAmount]) {
        NSCharacterSet *invalidCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        if ([string containsCharacterFromCharacterSet:invalidCharacterSet]) {
            return NO;
        }
    }
    
    NSString *value = field.value ? field.value : @"";
    value = [value stringByReplacingCharactersInRange:range withString:string];
    field.value = value;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    SPRTextField *theTextField = (SPRTextField *)textField;
    SPRField *field = theTextField.field;
    field.value = nil;
    
    return YES;
}

#pragma mark - Category picker view delegate

- (void)categoryPickerView:(SPRCategoryPickerView *)categoryPickerView didSelectCategory:(SPRCategory *)category
{
    SPRField *categoryField = self.fields[kRowCategory];
    categoryField.value = category;
    
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:kRowCategory inSection:0];
    
    // Reload the category cell to display the name of the selection.
    [self.tableView reloadRowsAtIndexPaths:@[categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Keep the category cell selected.
    [self.tableView selectRowAtIndexPath:categoryIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)willDismissCategoryPickerView:(SPRCategoryPickerView *)categoryPickerView
{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:kRowCategory inSection:0] animated:YES];
}

@end
