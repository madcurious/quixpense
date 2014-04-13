//
//  SPRCategory.h
//  Spare
//
//  Created by Matt Quiros on 4/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPRExpense;

@interface SPRCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * colorNumber;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *expenses;
@end

@interface SPRCategory (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(SPRExpense *)value;
- (void)removeExpensesObject:(SPRExpense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

@end
