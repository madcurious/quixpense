//
//  DayChartVC.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class DayChartVC: HomeChartVC {
    
    let customView = __DCVCView.instantiateFromNib()
    
    override var chartData: ChartData {
        didSet {
            self.runOperation()
        }
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func makeOperation() -> MDOperation? {
        return MDBlockOperation {[unowned self] in
            let request = FetchRequestBuilder<Expense>.makeGenericFetchRequest()
            request.predicate = NSPredicate(
                format: "%K >= %@ AND %K <= %@ AND %K == %@",
                #keyPath(Expense.dateSpent), self.chartData.dateRange.start as NSDate,
                #keyPath(Expense.dateSpent), self.chartData.dateRange.end as NSDate,
                #keyPath(Expense.category), self.chartData.category
            )
            request.resultType = .dictionaryResultType
            
            let sumExpression = NSExpressionDescription()
            sumExpression.name = "sum"
            sumExpression.expression = NSExpression(forKeyPath: "@sum.amount")
            sumExpression.expressionResultType = .decimalAttributeType
            request.propertiesToFetch = [sumExpression]
            
            // Initialize categoryTotal to 0 in case the request returns nothing
            // because there are no expenses in the date range.
            var categoryTotal = NSDecimalNumber(value: 0)
            let context = App.coreDataStack.newBackgroundContext()
            if let sum = (try context.fetch(request) as? [[String : NSDecimalNumber]])?.first?["sum"] {
                categoryTotal = sum
            }
            
            // Avoid division by 0.
            let percent = self.chartData.dateRangeTotal == 0 ? 0 : Double(categoryTotal / self.chartData.dateRangeTotal)
            let result = (categoryTotal, percent)
            
            return result
            }
            
            .onStart {[unowned self] in
                // Displays the category name immediately, but ellipses for total and percent labels.
                self.customView.chartData = self.chartData
            }
            
            .onSuccess({[unowned self] result in
                let (categoryTotal, percent) = result as! (NSDecimalNumber, Double)
                self.chartData.categoryTotal = categoryTotal
                self.chartData.percent = percent
                
                // Reset the chart data in the custom view to re-display the values.
                self.customView.chartData = self.chartData
            })
    }
    
}
