//
//  SPRHomeViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeViewController.h"

// Objects
#import "SPRCategory.h"

// Custom views
#import "SPRHomeTableViewCell.h"

@interface SPRHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;

@end

static NSString * const kCellIdentifier = @"Cell";

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Prepare the data source.
    self.categories = [SPRCategory dummies];
    
    // Register the table view cell class.
    [self.tableView registerClass:[SPRHomeTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPRHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.category = self.categories[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPRHomeTableViewCell heightForCategory:self.categories[indexPath.row]];
}

@end
