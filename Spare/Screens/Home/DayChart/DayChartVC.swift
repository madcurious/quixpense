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
    
    var total = NSDecimalNumber(value: 0)
    var percent = 0.0
    
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
            
            let context = App.coreDataStack.newBackgroundContext()
            guard let results = try context.fetch(request) as? [[String : NSDecimalNumber]],
                let categoryTotal = results[0]["sum"]
                else {
                    return nil
            }
            
            let result = (categoryTotal, categoryTotal / self.chartData.dateRangeTotal)
            return result
            }
            .onStart {[unowned self] in
                self.customView.data = nil
            }
            .onSuccess({[unowned self] result in
                let (total, percent) = result as! (NSDecimalNumber, Double)
                self.total = total
                self.percent = percent
                
                self.customView.data = (total, percent)
            })
    }
    
}
