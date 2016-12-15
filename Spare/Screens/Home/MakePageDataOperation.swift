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

class MakePageDataOperation: MDOperation {
    
    let dateRange: DateRange
    let periodization: Periodization
    
    lazy var weekdayFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "EEEEE"
        formatter.locale = Locale.current
        return formatter
    }()
    
    lazy var dayOfWeekFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "d"
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
        
        // 1. First, compute for the total of all expenses in the date range.
        // 2. Then, build the chart data for every category.
        
        // 1
        
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
        
        let context = App.coreDataStack.newBackgroundContext()
        let fetchResult = try! context.fetch(request) as! [[String : NSDecimalNumber]]
        let dateRangeTotal = fetchResult.first!["sum"] ?? 0
        
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
                    categoryTotal = sum
                }
            }
            
            if self.isCancelled {
                return nil
            }
            
            // Compute for the optional properties depending on the periodization.
            
            var dates: [String]?
            var weekdays: [String]?
            var dailyAverage: NSDecimalNumber?
            var percentages: [CGFloat]?
            
            switch self.periodization {
            case .day:
                break
                
            case .week:
                let numberOfDaysInAWeek = 7
                var dayOfWeek = self.dateRange.start
                dates = [String]()
                percentages = Array<CGFloat>(repeating: 0, count: numberOfDaysInAWeek)
                for i in 0 ..< numberOfDaysInAWeek {
                    // Append
                    dates?.append(self.dayOfWeekFormatter.string(from: dayOfWeek))
                    
                    // Get the total of expenses in that day and compute for its percentage
                    // relative to the category total.
                    // Avoid division by zero.
                    if categoryTotal > 0 {
                        var dailyTotal = NSDecimalNumber(value: 0)
                        let request = FetchRequestBuilder<Expense>.makeGenericRequest()
                        request.predicate = NSPredicate(
                            format: "%K >= %@ AND %K <= %@ AND %K == %@",
                            #keyPath(Expense.dateSpent), dayOfWeek.startOfDay() as NSDate,
                            #keyPath(Expense.dateSpent), dayOfWeek.endOfDay() as NSDate,
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
                        percentages?[i] = CGFloat(dailyTotal / categoryTotal)
                    }
                    
                    
                    // Move to the next day.
                    dayOfWeek = Calendar.current.date(byAdding: .day, value: 1, to: dayOfWeek)!
                    
                    if self.isCancelled {
                        return nil
                    }
                }
                
                weekdays = self.weekdayFormatter.veryShortWeekdaySymbols
                dailyAverage = categoryTotal / NSDecimalNumber(value: numberOfDaysInAWeek)
                
            case .month: ()
                
                
            case .year: ()
            }
            
            
            let newChartData = ChartData(categoryID: category.objectID,
                                         dateRangeTotal: dateRangeTotal,
                                         categoryTotal: categoryTotal,
                                         dates: dates,
                                         weekdays: weekdays,
                                         dailyAverage: dailyAverage,
                                         percentages: percentages)
            chartData.append(newChartData)
            
            if self.isCancelled {
                return nil
            }
        }
        
        chartData.sort(by: { $0.categoryTotal > $1.categoryTotal })
        
        let result = (dateRangeTotal, chartData)
        return result
    }
    
    func computeForDatesAndWeekdays() -> ([String], [String]) {
        guard self.periodization != .day
            else {
                fatalError("Dev error--can't call this for day periodization.")
        }
        
        return ([String](), [String]())
    }
    
}
