//
//  SPRHomeViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeViewController.h"

// Objects
#import "SPRCategory+Extension.h"
#import "SPRManagedDocument.h"

// Custom views
#import "SPRHomeTableViewCell.h"
#import "SPRStatusView.h"

// Utilities
#import "SPRIconFont.h"

// Categories
#import "UIView+SubviewFinder.h"

// View controllers
#import "SPRNewCategoryViewController.h"
#import "SPRCategoryViewController.h"

@interface SPRHomeViewController () <UITableViewDataSource, UITableViewDelegate, SPRNewCategoryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) SPRStatusView *statusView;
@property (weak, nonatomic) SPRCategory *selectedCategory;

@end

static NSString * const kCellIdentifier = @"Cell";

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Register the table view cell class.
    [self.tableView registerClass:[SPRHomeTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    // Add a long press gesture recognizer to the table view.
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongPressed)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    [self setupDefaultNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.categories == nil) {
        [self reloadTableView];
    }
}

- (void)reloadTableView
{
    // If the categories array is nil or has zero count,
    // the table view is not visible in the screen and we can therefore put
    // a status view on top of it.
    if (self.categories == nil || self.categories.count == 0) {
        [self.view addSubview:self.statusView];
        self.statusView.status = SPRStatusViewStatusLoading;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    SPRManagedDocument *managedDocument = [[SPRManagedDocument alloc] init];
    __weak SPRHomeViewController *weakSelf = self;
    
    [managedDocument prepareWithCompletionHandler:^(BOOL success) {
        SPRHomeViewController *innerSelf = weakSelf;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SPRCategory"];
        NSManagedObjectContext *context = managedDocument.managedObjectContext;
        NSError *error;
        
        innerSelf.categories = [context executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            NSLog(@"Error fetching all categories: %@", error);
        } else {
            if (innerSelf.categories.count > 0) {
                [innerSelf.statusView fadeOutAndRemoveFromSuperview];
                [innerSelf.tableView reloadData];
            } else {
                innerSelf.statusView.status = SPRStatusViewStatusNoResults;
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)setupDefaultNavigationBar
{
    self.title = nil;
    
    UIButton *newCategoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newCategoryButton setAttributedTitle:[SPRIconFont iconForNewCategory] forState:UIControlStateNormal];
    [newCategoryButton sizeToFit];
    [newCategoryButton addTarget:self action:@selector(newCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newCategoryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCategoryButton];
    
    self.navigationItem.rightBarButtonItems = @[newCategoryBarButtonItem];
}

- (void)setupEditingNavigationBar
{
    self.title = @"Reorder";
    
    UIBarButtonItem *doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditingButtonTapped)];
    
    self.navigationItem.rightBarButtonItems = @[doneEditingButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentNewCategoryModal"]) {
        UINavigationController *modalNavigationController = segue.destinationViewController;
        
        SPRNewCategoryViewController *newCategoryScreen = modalNavigationController.viewControllers[0];
        newCategoryScreen.delegate = self;
        return;
    }
    
    if ([segue.identifier isEqualToString:@"pushCategory"]) {
        SPRCategoryViewController *categoryScreen = segue.destinationViewController;
        categoryScreen.category = self.selectedCategory;
        return;
    }
}

#pragma mark - Target actions

- (void)newCategoryButtonTapped
{
    [self performSegueWithIdentifier:@"presentNewCategoryModal" sender:self];
}

- (void)tableViewLongPressed
{
    [self.tableView setEditing:YES animated:NO];
    [self.tableView reloadData];
    
    [self setupEditingNavigationBar];
}

- (void)doneEditingButtonTapped
{
    [self.tableView setEditing:NO animated:NO];
    [self.tableView reloadData];
    
    [self setupDefaultNavigationBar];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPRHomeTableViewCell heightForCategory:self.categories[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.selectedCategory = self.categories[indexPath.row];
        
        [self performSegueWithIdentifier:@"pushCategory" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This method is only relevant when the table view is in editing mode.
    if (!self.tableView.editing) {
        return;
    }
    
    // Blindly copying Tom Parry's code in
    // http://b2cloud.com.au/tutorial/reordering-a-uitableviewcell-from-any-touch-point/
    // which simply expands the width of the UITableViewCell's reorder control to the
    // full width of the table view cell.
    
    UIView *reorderControl = [cell subviewWithClassName:@"UITableViewCellReorderControl"];
    
    UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame))];
	[resizedGripView addSubview:reorderControl];
	[cell addSubview:resizedGripView];
    
	CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - reorderControl.frame.size.width, resizedGripView.frame.size.height - reorderControl.frame.size.height);
	CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / reorderControl.frame.size.width, resizedGripView.frame.size.height / reorderControl.frame.size.height);
    
	//	Original transform
	CGAffineTransform transform = CGAffineTransformIdentity;
    
	//	Scale custom view so grip will fill entire cell
	transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
    
	//	Move custom view so the grip's top left aligns with the cell's top left
	transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
    
	[resizedGripView setTransform:transform];
    
	for(UIImageView* cellGrip in reorderControl.subviews)
	{
		if([cellGrip isKindOfClass:[UIImageView class]])
			[cellGrip setImage:nil];
	}
}

#pragma mark - New category view controller delegate

- (void)newCategoryViewControllerDidAddCategory
{
    [self reloadTableView];
}

#pragma mark - Getters

- (SPRStatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[SPRStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _statusView.noResultsText = @"You have no categories yet.";
    }
    return _statusView;
}

@end
