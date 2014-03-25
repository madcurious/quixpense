//
//  SPRNewCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRNewCategoryViewController.h"

// Objects
#import "SPRCategory+Extension.h"

// App delegate
#import "SPRAppDelegate.h"

typedef NS_ENUM(NSInteger, kRow)
{
    kRowName = 0,
    kRowColor = 1,
};

static NSString * const kNameCell = @"kNameCell";
static NSString * const kColorCell = @"kColorCell";

static const NSInteger kTextFieldTag = 1000;
static const NSInteger kSelectedColorViewTag = 2000;

@interface SPRNewCategoryViewController () <UITextFieldDelegate>

@property (strong, nonatomic) SPRCategory *category;

@end

@implementation SPRNewCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the SPRCategory object.
    SPRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    self.category = [NSEntityDescription insertNewObjectForEntityForName:@"SPRCategory" inManagedObjectContext:context];
    
    // Make the table view dismiss the keyboard when it is tapped.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Target actions

- (void)tableViewTapped
{
    [self.view endEditing:YES];
}

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.row == kRowName) {
        identifier = kNameCell;
    } else {
        identifier = kColorCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.row == kRowName) {
        UITextField *textField = (UITextField *)[cell viewWithTag:kTextFieldTag];
        textField.delegate = self;
        
        textField.text = self.category.name;
    } else {
        UIView *selectedColorView = [cell viewWithTag:kSelectedColorViewTag];
        selectedColorView.backgroundColor = [SPRCategory colors][[self.category.colorNumber integerValue]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kRowColor) {
        // Reassert the background color of the selected color view so that it does
        // not disappear with the UITableViewCell highlight.
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIView *selectedColorView = [cell viewWithTag:kSelectedColorViewTag];
        selectedColorView.backgroundColor = [SPRCategory colors][[self.category.colorNumber integerValue]];
        
        // Remove the table view cell highlight.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Set the category's name to whatever is in the text field.
    self.category.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.category.name = @"";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Trim the trailing whitespaces in the category's name.
    self.category.name = [self.category.name trim];
    textField.text = self.category.name;
}

@end
