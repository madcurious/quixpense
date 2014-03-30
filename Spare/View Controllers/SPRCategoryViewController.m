//
//  SPRCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryViewController.h"

// Custom views
#import "SPRCategoryHeaderView.h"

// Objects
#import "SPRCategory+Extension.h"

// Utilities
#import "SPRIconFont.h"

@interface SPRCategoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPRCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    SPRCategoryHeaderView *headerView = [[SPRCategoryHeaderView alloc] initWithCategory:self.category];
    self.tableView.tableHeaderView = headerView;
}

- (void)setupBarButtonItems
{
    UIButton *newExpenseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newExpenseButton setAttributedTitle:[SPRIconFont iconForNewExpense] forState:UIControlStateNormal];
    [newExpenseButton sizeToFit];
    [newExpenseButton addTarget:self action:@selector(newExpenseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newExpenseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newExpenseButton];
    
    self.navigationItem.rightBarButtonItems = @[newExpenseBarButtonItem];
}

#pragma mark - Target actions

- (void)newExpenseButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewExpense" sender:self];
}

@end
