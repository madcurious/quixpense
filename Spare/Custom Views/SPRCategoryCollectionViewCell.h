//
//  SPRCategoryCollectionViewCell.h
//  Spare
//
//  Created by Matt Quiros on 4/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategory;

@interface SPRCategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) SPRCategory *category;
@property (weak, nonatomic) NSDecimalNumber *displayedTotal;

@end
