//
//  HomeChartVC.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class HomeChartVC: UIViewController {
    
    var operationQueue = OperationQueue()
    var chartData = ChartData()
    
    
    func makeOperation() -> MDOperation? {
        return nil
    }
    
    func runOperation() {
        guard let operation = self.makeOperation()
            else {
                return
        }
        
        self.operationQueue.addOperation(operation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runOperation()
    }
    
    class func applyAttributes(toNameLabel label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Heavy, 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    class func applyAttributes(toTotalLabel label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Book, 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
    }
    
}
