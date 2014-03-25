//
//  SPRNewCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRNewCategoryViewController.h"

// Objects
#import "SPRCategory.h"

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
    return 1;
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
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Set the category's name to whatever is in the text field.
    self.category.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Trim the trailing whitespaces in the category's name.
    self.category.name = [self.category.name trim];
}

@end
