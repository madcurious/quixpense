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
            
            // Compute for the optional properties depending on the periodization.
            
            var dates: [Int]?
            var weekdays: [String]?
            var dailyAverage: NSDecimalNumber?
            var dailyPercentages: [CGFloat]?
            
            switch self.periodization {
            case .day:
                break
                
            case .week:
                dailyAverage = categoryTotal / NSDecimalNumber(value: kNumberOfDaysInAWeek)
                dates = self.getDatesOfTheWeek()
                weekdays = self.weekdayFormatter.veryShortWeekdaySymbols
                dailyPercentages = try self.getDailyPercentages(forCategory: category, inContext: context)
                
            case .month: ()
//                dates = self.getDatesOfTheMonth()
            
                let numberOfDaysInTheMonth = Calendar.current.numberOfDaysInMonth(of: self.dateRange.start)
                dailyAverage = categoryTotal / NSDecimalNumber(value: numberOfDaysInTheMonth)
                
                dailyPercentages = try self.getDailyPercentages(forCategory: category, inContext: context)
                
                
            case .year: ()
            }
            
            
            let newChartData = ChartData(categoryID: category.objectID,
                                         dateRangeTotal: dateRangeTotal,
                                         categoryTotal: categoryTotal,
                                         dates: dates,
                                         weekdays: weekdays,
                                         dailyAverage: dailyAverage,
                                         dailyPercentages: dailyPercentages)
            chartData.append(newChartData)
            
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
    
//    func getDatesOfTheMonth() -> [Int] {
//        var dates = kConstantDatesOfTheMonth
//        let numberOfDaysInTheMonth = Calendar.current.numberOfDaysInMonth(of: self.dateRange.start)
//        if numberOfDaysInTheMonth >= 29 {
//            dates.append(29)
//        }
//        return dates
//    }
    
    /**
     Returns the bar heights as an array of fractions, from 0 to 1. The maximum expense is always 1 and the other heights
     are a fraction of the maximum.
     */
    func getDailyPercentages(forCategory category: Category, inContext context: NSManagedObjectContext) throws -> [CGFloat] {
        var date = self.dateRange.start
        var dailyTotals = [NSDecimalNumber]()
        
        let numberOfDays: Int = {
            switch self.periodization {
            case .week:
                return 7
                
            default:
                let numberOfDaysInMonth = Calendar.current.numberOfDaysInMonth(of: date)
                return numberOfDaysInMonth
            }
        }()
        
        for _ in 0 ..< numberOfDays {
            var dailyTotal = NSDecimalNumber(value: 0)
            
            let request = FetchRequestBuilder<Expense>.makeGenericRequest()
            request.predicate = NSPredicate(
                format: "%K >= %@ AND %K <= %@ AND %K == %@",
                #keyPath(Expense.dateSpent), date.startOfDay() as NSDate,
                #keyPath(Expense.dateSpent), date.endOfDay() as NSDate,
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
                dailyTotal = sum
            }
            
            dailyTotals.append(dailyTotal)
            
            // Move to the next day.
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        var dailyPercentages = Array<CGFloat>(repeating: 0, count: numberOfDays)
        
        // Avoid division by zero.
        if let maxDailyTotal = dailyTotals.max(by: { $0 < $1 }),
            maxDailyTotal > 0 {
            for i in 0 ..< numberOfDays {
                dailyPercentages[i] = CGFloat(dailyTotals[i] / maxDailyTotal)
            }
        }
        
        return dailyPercentages
    }
    
}
