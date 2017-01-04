//
//  MakePageDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 07/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

private let kNumberOfDaysInAWeek = 7
private let kConstantDatesOfTheMonth = [1, 8, 15, 22]

class MakePageDataOperation: MDOperation {
    
    let dateRange: DateRange
    let periodization: Periodization
    
    lazy var weekdayFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "EEEEE"
        formatter.locale = Locale.current
        return formatter
    }()
    
    init(dateRange: DateRange, periodization: Periodization) {
        self.dateRange = dateRange
        self.periodization = periodization
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        if self.isCancelled {
            return nil
        }
        
        let context = App.coreDataStack.newBackgroundContext()
        
        // 1. First, compute for the total of all expenses in the date range.
        // 2. Then, build the chart data for every category.
        
        // 1
        
        let dateRangeTotal = try self.getDateRangeTotal(inContext: context)
        
        if self.isCancelled {
            return nil
        }
        
        // 2
        
        let categories = try Category.fetchAll(inContext: context, sortedBy: nil)
        
        var chartData = [ChartData]()
        for category in categories {
            var categoryTotal = NSDecimalNumber(value: 0)
            
            // Compute for the category total only if there are any expenses in the date range.
            // This is to avoid division by zero when computing for the category percentage or ratio.
            if dateRangeTotal > 0 {
                categoryTotal = try self.getCategoryTotal(for: category, inContext: context)
            }
            
            if self.isCancelled {
                return nil
            }
            
            var newData = ChartData(categoryID: category.objectID, dateRangeTotal: dateRangeTotal, categoryTotal: categoryTotal, periodization: self.periodization)
            
            // Compute for the optional properties depending on the periodization.
            switch self.periodization {
            case .day:
                break
                
            case .week:
                newData.dailyAverage = categoryTotal / NSDecimalNumber(value: kNumberOfDaysInAWeek)
                newData.datesInWeek = self.getDatesOfTheWeek()
                newData.weekdays = self.weekdayFormatter.veryShortWeekdaySymbols
                newData.dailyPercentages = try self.getPercentages(forCategory: category, inContext: context)
                
            case .month: ()
                let numberOfDaysInTheMonth = Calendar.current.numberOfDaysInMonth(of: self.dateRange.start)
                newData.dailyAverage = categoryTotal / NSDecimalNumber(value: numberOfDaysInTheMonth)
                newData.dailyPercentages = try self.getPercentages(forCategory: category, inContext: context)
                
                
            case .year:
                newData.monthlyAverage = categoryTotal / 12
                newData.monthlyPercentages = try self.getPercentages(forCategory: category, inContext: context)
            }
            
            chartData.append(newData)
            
            if self.isCancelled {
                return nil
            }
        }
        
        chartData.sort(by: { $0.categoryTotal > $1.categoryTotal })
        
        let result = (dateRangeTotal, chartData)
        return result
    }
    
    /**
     Gets the total of all expenses in all categories within the date range.
     */
    func getDateRangeTotal(inContext context: NSManagedObjectContext) throws -> NSDecimalNumber {
        let request = FetchRequestBuilder<Expense>.makeGenericRequest()
        request.predicate = NSPredicate(
            format: "%K >= %@ AND %K <= %@",
            #keyPath(Expense.dateSpent), dateRange.start as NSDate,
            #keyPath(Expense.dateSpent), dateRange.end as NSDate
        )
        request.resultType = .dictionaryResultType
        
        let sumExpression = NSExpressionDescription()
        sumExpression.name = "sum"
        sumExpression.expression = NSExpression(forKeyPath: "@sum.amount")
        sumExpression.expressionResultType = .decimalAttributeType
        request.propertiesToFetch = [sumExpression]
        
        let fetchResult = try context.fetch(request) as! [[String : NSDecimalNumber]]
        
        if let dateRangeTotal = fetchResult.first?["sum"] {
            return dateRangeTotal
        }
        return 0
    }
    
    /**
     Gets the total of all expenses in the category, given the operation's date range.
     Best not to call this function if the date range total has already been found to be zero.
     */
    func getCategoryTotal(for category: Category, inContext context: NSManagedObjectContext) throws -> NSDecimalNumber {
        let request = FetchRequestBuilder<Expense>.makeGenericRequest()
        request.predicate = NSPredicate(
            format: "%K >= %@ AND %K <= %@ AND %K == %@",
            #keyPath(Expense.dateSpent), self.dateRange.start as NSDate,
            #keyPath(Expense.dateSpent), self.dateRange.end as NSDate,
            #keyPath(Expense.category), category
        )
        request.resultType = .dictionaryResultType
        
        let sumExpression = NSExpressionDescription()
        sumExpression.name = "sum"
        sumExpression.expressionResultType = .decimalAttributeType
        sumExpression.expression = NSExpression(forKeyPath: "@sum.amount")
        request.propertiesToFetch = [sumExpression]
        
        if let array = try context.fetch(request) as? [[String : NSDecimalNumber]],
            let dict = array.first,
            let sum = dict["sum"] {
            return sum
        }
        return 0
    }
    
    func getDatesOfTheWeek() -> [Int] {
        var dates = [Int]()
        var dayOfWeek = self.dateRange.start
        for _ in 0 ..< kNumberOfDaysInAWeek {
            let day = Calendar.current.component(.day, from: dayOfWeek)
            dates.append(day)
            
            // Move to the next day.
            dayOfWeek = Calendar.current.date(byAdding: .day, value: 1, to: dayOfWeek)!
        }
        return dates
    }
    
    /**
     Returns the bars in a graph represented as height percentages from 0 to 1. The highest non-zero
     total is always 1.0 and all other bars are percentages of it.
     
     For week and month views, the percentages represent a day. For the year view, each percentage is a month.
     A crash is produced if called with a day periodization.
     */
    func getPercentages(forCategory category: Category, inContext context: NSManagedObjectContext) throws -> [CGFloat] {
        var referenceDate = self.dateRange.start
        var totals = [NSDecimalNumber]()
        
        let numberOfItems: Int = {
            switch self.periodization {
            case .week:
                return 7
                
            case .month:
                let numberOfDaysInMonth = Calendar.current.numberOfDaysInMonth(of: referenceDate)
                return numberOfDaysInMonth
                
            case .year:
                return 12
                
            default:
                fatalError("Can't call \(#function) for periodization \(self.periodization)")
            }
        }()
        
        // Compute for the individual totals that represent each bar.
        // Later, we compute the percentages based on the highest total we find.
        let skipComponent = self.periodization == .year ? Calendar.Component.month : .day
        for _ in 0 ..< numberOfItems {
            var individualTotal = NSDecimalNumber(value: 0)
            
            let request = FetchRequestBuilder<Expense>.makeGenericRequest()
            let fromDate: NSDate = {
                if self.periodization == .year {
                    return referenceDate.startOfMonth() as NSDate
                }
                return referenceDate.startOfDay() as NSDate
            }()
            let toDate: NSDate = {
                if self.periodization == .year {
                    return referenceDate.endOfMonth() as NSDate
                }
                return referenceDate.endOfDay() as NSDate
            }()
            
            print("referenceDate: \(MDDateFormatter.string(for: referenceDate)!)\nfromDate: \(MDDateFormatter.string(for: fromDate)!)\ntoDate: \(MDDateFormatter.string(for: toDate)!)\n---")
            
            request.predicate = NSPredicate(
                format: "%K >= %@ AND %K <= %@ AND %K == %@",
                #keyPath(Expense.dateSpent), fromDate,
                #keyPath(Expense.dateSpent), toDate,
                #keyPath(Expense.category), category
            )
            request.resultType = .dictionaryResultType
            let sumExpression = NSExpressionDescription()
            sumExpression.name = "sum"
            sumExpression.expressionResultType = .decimalAttributeType
            sumExpression.expression = NSExpression(forKeyPath: "@sum.amount")
            request.propertiesToFetch = [sumExpression]
            
            if let array = try context.fetch(request) as? [[String : NSDecimalNumber]],
                let dict = array.first,
                let sum = dict["sum"] {
                individualTotal = sum
            }
            
            totals.append(individualTotal)
            
            // Advance to the next reference date for the next bar.
            referenceDate = Calendar.current.date(byAdding: skipComponent, value: 1, to: referenceDate)!
        }
        
        var percentages = Array<CGFloat>(repeating: 0, count: numberOfItems)
        
        // Avoid division by zero.
        if let highestTotal = totals.max(by: { $0 < $1 }),
            highestTotal > 0 {
            for i in 0 ..< numberOfItems {
                percentages[i] = CGFloat(totals[i] / highestTotal)
            }
        }
        
        return percentages
    }
    
}
