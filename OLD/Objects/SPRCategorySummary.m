//
//  SPRCategorySummary.m
//  Spare
//
//  Created by Matt Quiros on 5/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategorySummary.h"

// Objects
#import "SPRExpense+Extension.h"
#import "SPRManagedDocument.h"

@interface SPRCategorySummary ()

@property (strong, nonatomic) NSFetchedResultsController *dailyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *weeklyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *monthlyTotalFetcher;
@property (strong, nonatomic) NSFetchedResultsController *yearlyTotalFetcher;

@end

@implementation SPRCategorySummary

- (id)init
{
    self = [self initWithCategory:nil];
    return self;
}

- (instancetype)initWithCategory:(SPRCategory *)category
{
    if (self = [super init]) {
        _category = category;
    }
    return self;
}

- (NSDecimalNumber *)totalForTimeFrame:(SPRTimeFrame)timeFrame
{
    NSArray *fetchers = @[self.dailyTotalFetcher, self.weeklyTotalFetcher, self.monthlyTotalFetcher, self.yearlyTotalFetcher];
    NSFetchedResultsController *fetcher = fetchers[timeFrame];
    [fetcher performFetch:nil];
    NSDictionary *dictionary = fetcher.fetchedObjects[0];
    NSDecimalNumber *total = dictionary[@"total"];
    return total;
}

#pragma mark - Getters

- (NSFetchedResultsController *)dailyTotalFetcher
{
    if (_dailyTotalFetcher) {
        return _dailyTotalFetcher;
    }
    
    _dailyTotalFetcher = [SPRCategorySummary totalFetcherForCategory:self.category timeFrame:SPRTimeFrameDay];
    return _dailyTotalFetcher;
}

- (NSFetchedResultsController *)weeklyTotalFetcher
{
    if (_weeklyTotalFetcher) {
        return _weeklyTotalFetcher;
    }
    
    _weeklyTotalFetcher = [SPRCategorySummary totalFetcherForCategory:self.category timeFrame:SPRTimeFrameWeek];
    return _weeklyTotalFetcher;
}

- (NSFetchedResultsController *)monthlyTotalFetcher
{
    if (_monthlyTotalFetcher) {
        return _monthlyTotalFetcher;
    }
    
    _monthlyTotalFetcher = [SPRCategorySummary totalFetcherForCategory:self.category timeFrame:SPRTimeFrameMonth];
    return _monthlyTotalFetcher;
}

- (NSFetchedResultsController *)yearlyTotalFetcher
{
    if (_yearlyTotalFetcher) {
        return _yearlyTotalFetcher;
    }
    
    _yearlyTotalFetcher = [SPRCategorySummary totalFetcherForCategory:self.category timeFrame:SPRTimeFrameYear];
    return _yearlyTotalFetcher;
}

#pragma mark -

+ (NSFetchedResultsController *)totalFetcherForCategory:(SPRCategory *)category timeFrame:(SPRTimeFrame)timeFrame
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRExpense class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    NSDate *currentDate = [NSDate date];
    NSDate *startDate = [currentDate firstMomentInTimeFrame:timeFrame];
    NSDate *endDate = [currentDate lastMomentInTimeFrame:timeFrame];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@ AND dateSpent >= %@ AND dateSpent <= %@", category, startDate, endDate];
    fetchRequest.predicate = predicate;
    
    NSExpressionDescription *totalColumn = [[NSExpressionDescription alloc] init];
    totalColumn.name = @"total";
    totalColumn.expression = [NSExpression expressionWithFormat:@"@sum.amount"];
    totalColumn.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[totalColumn];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateSpent" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
