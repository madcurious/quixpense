//
//  SPREditExpenseViewController.h
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRExpense;

@protocol SPREditExpenseViewControllerDelegate <NSObject>

- (void)editExpenseScreenDidDeleteExpense:(SPRExpense *)expense atCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface SPREditExpenseViewController : UITableViewController

@property (weak, nonatomic) id<SPREditExpenseViewControllerDelegate> delegate;
@property (strong, nonatomic) SPRExpense *expense;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (strong, nonatomic) NSArray *nextExpenses;

@end
