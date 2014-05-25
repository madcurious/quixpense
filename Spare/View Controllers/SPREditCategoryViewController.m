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
#import "SPRManagedDocument.h"

// Custom views
#import "SPRCategoryNameCell.h"
#import "SPRCategoryColorCell.h"

static NSString * const kNameCell = @"kNameCell";
static NSString * const kColorCell = @"kColorCell";

@interface SPREditCategoryViewController ()

@property (strong, nonatomic) SPRCategory *category;
@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) NSArray *cellIdentifiers;

@end

@implementation SPREditCategoryViewController

- (instancetype)initWithCategory:(SPRCategory *)category
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
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
    
    self.cellIdentifiers = @[kNameCell, kColorCell];
    
    // Register table view cell classes.
    [self.tableView registerClass:[SPRCategoryNameCell class] forCellReuseIdentifier:kNameCell];
    [self.tableView registerClass:[SPRCategoryColorCell class] forCellReuseIdentifier:kColorCell];
    
    [self setupBarButtonItems];
}

- (void)setupBarButtonItems
{
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}

#pragma mark - Target actions

- (void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped
{
    self.category.name = ((SPRField *)self.fields[0]).value;
    self.category.colorNumber = ((SPRField *)self.fields[1]).value;
    
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    __weak SPREditCategoryViewController *weakSelf = self;
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        SPREditCategoryViewController *innerSelf = weakSelf;
        if ([innerSelf.delegate respondsToSelector:@selector(editCategoryScreen:didEditCategory:)]) {
            [innerSelf.delegate editCategoryScreen:innerSelf didEditCategory:innerSelf.category];
        }
        [innerSelf dismissViewControllerAnimated:YES completion:nil];
    }];
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
    NSString *identifier = self.cellIdentifiers[indexPath.row];
    SPRFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.field = self.fields[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
