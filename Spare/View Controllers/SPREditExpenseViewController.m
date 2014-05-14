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

static NSString * const kDescriptionCell = @"kDescriptionCell";
static NSString * const kAmountCell = @"kAmountCell";

typedef NS_ENUM(NSUInteger, kRow)
{
    kRowDescription = 0,
    kRowAmount = 1,
    kRowCategory,
    kRowDateSpent,
};

@interface SPREditExpenseViewController ()

@property (strong, nonatomic) NSArray *cellIdentifiers;

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
    
    // Set up the bar button items.
    [self setupBarButtonItems];
    
    self.cellIdentifiers = @[kDescriptionCell, kAmountCell];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}


@end
