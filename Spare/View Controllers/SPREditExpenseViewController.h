//
//  SPREditExpenseViewController.h
//  Spare
//
//  Created by Matt Quiros on 5/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRExpense;

@interface SPREditExpenseViewController : UITableViewController

@property (strong, nonatomic) SPRExpense *expense;

@end
