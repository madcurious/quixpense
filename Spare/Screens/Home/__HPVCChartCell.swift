//
//  __HPVCChartCell.swift
//  Spare
//
//  Created by Matt Quiros on 07/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HPVCChartCell: UICollectionViewCell {
    
    var chartData: ChartData?
    
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
    
    class func applyAttributes(toNoExpensesLabel label: UILabel) {
        label.textColor = UIColor(hex: 0x666666)
        label.font = Font.make(.Medium, 20)
        label.text = "No expenses"
    }
    
    class func height(for chartData: ChartData, atCellWidth cellWidth: CGFloat) -> CGFloat {
        fatalError()
    }
    
}
