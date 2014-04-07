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
#import "SPRManagedDocument.h"
#import "SPRField.h"

// View Controllers
#import "SPRColorChooserViewController.h"

typedef NS_ENUM(NSInteger, kRow)
{
    kRowName = 0,
    kRowColor = 1,
};

static NSString * const kNameCell = @"kNameCell";
static NSString * const kColorCell = @"kColorCell";

static const NSInteger kTextFieldTag = 1000;
static const NSInteger kSelectedColorViewTag = 2000;

@interface SPRNewCategoryViewController () <UITextFieldDelegate, SPRColorChooserViewControllerDelegate>

@property (strong, nonatomic) NSArray *fields;

@end

@implementation SPRNewCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _fields = @[[[SPRField alloc] initWithName:@"Name"],
                [[SPRField alloc] initWithName:@"Color"]];
    
    // Make the table view dismiss the keyboard when it is tapped.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    SPRColorChooserViewController *colorChooser = navigationController.viewControllers[0];
    colorChooser.delegate = self;
    
    SPRField *colorField = self.fields[kRowColor];
    colorChooser.selectedColorNumber = [colorField.value integerValue];
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
    SPRField *nameField = self.fields[kRowName];
    if (((NSString *)nameField.value).length > 0) {
        // Create the SPRCategory object.
        SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
        
        SPRCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"SPRCategory" inManagedObjectContext:document.managedObjectContext];
        category.name = (NSString *)((SPRField *)self.fields[kRowName]).value;
        category.colorNumber = ((SPRField *)self.fields[kRowColor]).value;
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if ([self.delegate respondsToSelector:@selector(newCategoryViewControllerDidAddCategory)]) {
                [self.delegate newCategoryViewControllerDidAddCategory];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
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
    SPRField *field = self.fields[indexPath.row];
    
    if (indexPath.row == kRowName) {
        UITextField *textField = (UITextField *)[cell viewWithTag:kTextFieldTag];
        textField.delegate = self;
        
        textField.text = (NSString *)field.value;
    } else {
        UIView *selectedColorView = [cell viewWithTag:kSelectedColorViewTag];
        selectedColorView.backgroundColor = [SPRCategory colors][[field.value integerValue] ];
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
        
        SPRField *colorField = self.fields[kRowColor];
        selectedColorView.backgroundColor = [SPRCategory colors][[colorField.value integerValue]];
        
        // Remove the table view cell highlight.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Color chooser view controller delegate

- (void)colorChooserDidSelectColorNumber:(NSInteger)colorNumber
{
    SPRField *colorField = self.fields[kRowColor];
    colorField.value = @(colorNumber);
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kRowColor inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Set the category's name to whatever is in the text field.
    SPRField *nameField = self.fields[kRowName];
    nameField.value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    SPRField *nameField = self.fields[kRowName];
    nameField.value = @"";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Trim the trailing whitespaces in the category's name.
    SPRField *nameField = self.fields[kRowName];
    nameField.value = [((NSString *)nameField.value) trim];
    textField.text = nameField.value;
}

@end
