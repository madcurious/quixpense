//
//  MakeChartDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 07/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class MakeChartDataOperation: MDOperation {
    
    let pageData: PageData
    let periodization: Periodization
    
    init(pageData: PageData, periodization: Periodization) {
        self.pageData = pageData
        self.periodization = periodization
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let context = App.coreDataStack.newBackgroundContext()
        let categories = try Category.fetchAll(inContext: context)
        
        var chartData = [ChartData]()
        for category in categories {
            var categoryTotal = NSDecimalNumber(value: 0)
            var ratio = 0.0
            
            // Avoid division by zero.
            if self.pageData.dateRangeTotal > 0 {
                let request = FetchRequestBuilder<Expense>.makeGenericRequest()
                request.predicate = NSPredicate(
                    format: "%K >= %@ AND %K <= %@ AND %K == %@",
                    #keyPath(Expense.dateSpent), self.pageData.dateRange.start as NSDate,
                    #keyPath(Expense.dateSpent), self.pageData.dateRange.end as NSDate,
                    #keyPath(Expense.category.objectID), category
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
                    ratio = Double(categoryTotal / self.pageData.dateRangeTotal)
                }
            }
            
            let newChartData = ChartData(categoryID: category.objectID,
                                         dateRange: self.pageData.dateRange,
                                         dateRangeTotal: self.pageData.dateRangeTotal,
                                         categoryTotal: categoryTotal,
                                         ratio: ratio)
            chartData.append(newChartData)
            
            if self.isCancelled {
                return nil
            }
        }
        
        return chartData
    }
    
}
