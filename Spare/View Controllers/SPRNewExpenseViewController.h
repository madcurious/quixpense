//
//  SPRNewExpenseViewController.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPRNewExpenseViewControllerDelegate <NSObject>

- (void)newExpenseViewControllerDidAddExpense;

@end

@interface SPRNewExpenseViewController : UITableViewController

@property (weak, nonatomic) id<SPRNewExpenseViewControllerDelegate> delegate;
@property (nonatomic) NSInteger categoryIndex;

@end
