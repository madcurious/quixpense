//
//  SPREditCategoryViewController.m
//  Spare
//
//  Created by Matt Quiros on 5/16/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPREditCategoryViewController.h"

// Objects
#import "SPRField.h"
#import "SPRCategory+Extension.h"

@interface SPREditCategoryViewController ()

@property (strong, nonatomic) SPRCategory *category;
@property (strong, nonatomic) NSArray *fields;

@end

@implementation SPREditCategoryViewController

- (instancetype)initWithCategory:(SPRCategory *)category
{
    if (self = [super init]) {
        self.title = @"Edit Category";
        _category = category;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fields = @[[[SPRField alloc] initWithValue:self.category.name],
                    [[SPRField alloc] initWithValue:self.category.colorNumber]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    return cell;
}

#pragma mark - Table view delegate

@end
