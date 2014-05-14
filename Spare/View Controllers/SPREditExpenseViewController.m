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

// Objects
#import "SPRField.h"
#import "SPRExpense.h"

static NSString * const kDescriptionCell = @"kDescriptionCell";
static NSString * const kAmountCell = @"kAmountCell";
static NSString * const kCategoryCell = @"kCategoryCell";
static NSString * const kDateSpentCell = @"kDateSpentCell";

typedef NS_ENUM(NSUInteger, kRow)
{
    kRowDescription = 0,
    kRowAmount = 1,
    kRowCategory,
    kRowDateSpent,
};

@interface SPREditExpenseViewController ()

@property (strong, nonatomic) NSArray *cellIdentifiers;
@property (strong, nonatomic) NSArray *fields;

@end

@implementation SPREditExpenseViewController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = @"Edit";
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellIdentifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifiers[indexPath.row];
    SPRFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.field = self.fields[indexPath.row];
    return cell;
}

@end
