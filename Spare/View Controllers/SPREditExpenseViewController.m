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

static NSString * const kDescriptionCell = @"kDescriptionCell";

@interface SPREditExpenseViewController ()



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
    
    // Register a table view cell class.
    [self.tableView registerClass:[SPRExpenseDescriptionCell class] forCellReuseIdentifier:kDescriptionCell];
    
    // Set up the bar button items.
    [self setupBarButtonItems];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = kDescriptionCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}


@end
