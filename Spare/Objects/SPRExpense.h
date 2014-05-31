//
//  SPRExpense.h
//  Spare
//
//  Created by Matt Quiros on 5/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPRCategory;

@interface SPRExpense : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * dateLastModified;
@property (nonatomic, retain) NSString * dateSpentAsSectionTitle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dateSpent;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) SPRCategory *category;

@end
