//
//  SPRExpense.h
//  Pods
//
//  Created by Matt Quiros on 4/29/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPRCategory;

@interface SPRExpense : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * dateSpent;
@property (nonatomic, retain) NSString * dateSpentAsSectionTitle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SPRCategory *category;

@end
