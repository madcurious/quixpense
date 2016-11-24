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
    
    init(dateRange: DateRange, periodization: Periodization) {
        self.dateRange = dateRange
        self.periodization = periodization
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
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
        
        // 2
        
        let categories = try Category.fetchAll(inContext: context)
        
        var chartData = [ChartData]()
        for category in categories {
            var categoryTotal = NSDecimalNumber(value: 0)
            
            // Avoid division by zero.
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
            
            let newChartData = ChartData(categoryID: category.objectID,
                                         dateRange: self.dateRange,
                                         dateRangeTotal: dateRangeTotal,
                                         categoryTotal: categoryTotal)
            chartData.append(newChartData)
            
            if self.isCancelled {
                return nil
            }
        }
        
        chartData.sort(by: { $0.categoryTotal > $1.categoryTotal })
        
        let result = (dateRangeTotal, chartData)
        return result
    }
    
}
