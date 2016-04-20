//
//  SPREditCategoryViewController.h
//  Spare
//
//  Created by Matt Quiros on 5/16/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPREditCategoryViewController, SPRCategory;

@protocol SPREditCategoryViewControllerDelegate <NSObject>

- (void)editCategoryScreen:(SPREditCategoryViewController *)editCategoryScreen didEditCategory:(SPRCategory *)category;

@end

@interface SPREditCategoryViewController : UITableViewController

@property (weak, nonatomic) id<SPREditCategoryViewControllerDelegate> delegate;

- (instancetype)initWithCategory:(SPRCategory *)category;

@end
