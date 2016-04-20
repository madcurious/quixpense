//
//  SPRNewExpenseViewController.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategory, SPRNewExpenseViewController, SPRExpense;

@protocol SPRNewExpenseViewControllerDelegate <NSObject>

- (void)newExpenseScreenDidAddExpense:(SPRExpense *)expense;

@end

@interface SPRNewExpenseViewController : UITableViewController

@property (strong, nonatomic) SPRCategory *category;
@property (weak, nonatomic) id<SPRNewExpenseViewControllerDelegate> delegate;

@end
