//
//  SPRCategory.h
//  Spare
//
//  Created by Matt Quiros on 3/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SPRCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * colorNumber;

@end
