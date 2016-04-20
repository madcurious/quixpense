//
//  SPRColorChooserViewController.m
//  Spare
//
//  Created by Matt Quiros on 3/26/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRColorChooserViewController.h"

// Objects
#import "SPRCategory+Extension.h"

// Custom views
#import "SPRColorChooserSectionHeader.h"

static NSString * const kCellIdentifier = @"Cell";
static NSString * const kSectionHeaderView = @"kSectionHeaderView";

static const NSInteger kColorViewTag = 1000;

@interface SPRColorChooserViewController ()

@property (strong, nonatomic) NSArray *sectionTitles;

@end

@implementation SPRColorChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionTitles = @[@"Canary", @"Neon", @"Ultra", @"Tropical", @"Samba", @"Aquatic", @"Sunbrite", @"Classic"];
}

- (NSInteger)colorNumberForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger base = indexPath.section > 0 ? 1 : 0;
    NSInteger offset = indexPath.section > 0 ? (5 * (indexPath.section - 1)) : 0;
    NSInteger row = indexPath.row;
    
    NSInteger colorNumber = base + offset + row;
    return colorNumber;
}

- (NSIndexPath *)indexPathForColorNumber:(NSInteger)colorNumber
{
    NSIndexPath *indexPath;
    
    NSInteger base = colorNumber > 0 ? 1 : 0;
    
    NSInteger row = (colorNumber - base) % 5;
    NSInteger section = colorNumber > 0 ? (colorNumber - (base + row)) / 5 + 1 : 0;
    
    indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return indexPath;
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(colorChooserDidSelectColorNumber:)]) {
        [self.delegate colorChooserDidSelectColorNumber:self.selectedColorNumber];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // There are 8 groups in the list of category colors.
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // The first section contains only 1 color.
    // The rest contains 5 each.
    if (section == 0) {
        return 1;
    }
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSInteger indexPathAsColorNumber = [self colorNumberForIndexPath:indexPath];
    
    UIView *colorView = [cell viewWithTag:kColorViewTag];
    colorView.backgroundColor = [SPRCategory colors][indexPathAsColorNumber];
    
    if (indexPathAsColorNumber == self.selectedColorNumber) {
        cell.backgroundColor = [UIColor darkGrayColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SPRColorChooserSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderView forIndexPath:indexPath];
        
        headerView.titleLabel.text = self.sectionTitles[indexPath.section];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If the selected index path is the same color number, do nothing.
    NSInteger indexPathAsColorNumber = [self colorNumberForIndexPath:indexPath];
    if (self.selectedColorNumber == indexPathAsColorNumber) {
        return;
    }
    
    // Otherwise, transfer the cell highlight to the new index path.
    NSIndexPath *indexPathOfOldSelection = [self indexPathForColorNumber:self.selectedColorNumber];
    self.selectedColorNumber = [self colorNumberForIndexPath:indexPath];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPathOfOldSelection, indexPath]];
}

#pragma mark - Collection view flow layout delegate


@end
