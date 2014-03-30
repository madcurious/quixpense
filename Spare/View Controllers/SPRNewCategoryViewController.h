//
//  SPRNewCategoryViewController.h
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPRNewCategoryViewControllerDelegate <NSObject>

- (void)newCategoryViewControllerDidAddCategory;

@end

@interface SPRNewCategoryViewController : UITableViewController

@property (weak, nonatomic) id<SPRNewCategoryViewControllerDelegate> delegate;

@end
