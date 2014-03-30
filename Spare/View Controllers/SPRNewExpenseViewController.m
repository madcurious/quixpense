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

// Custom views
#import "SPRTextField.h"

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

@interface SPRNewExpenseViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *identifiers;
@property (strong, nonatomic) NSArray *fields;

@end

@implementation SPRNewExpenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.identifiers = @[kDescriptionCell, kAmountCell, kCategoryCell, kDateSpentCell];
    
    self.fields = @[[[SPRField alloc] initWithName:@"Description"],
                    [[SPRField alloc] initWithName:@"Amount"],
                    [[SPRField alloc] initWithName:@"Category" value:self.category],
                    [[SPRField alloc] initWithName:@"Date spent" value:[NSDate date]]];
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SPRTextField *theTextField = (SPRTextField *)textField;
    SPRField *field = theTextField.field;
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

@end
