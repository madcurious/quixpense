//
//  _HPVCChartCell.swift
//  Spare
//
//  Created by Matt Quiros on 07/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

/**
 Parent class for the chart cells that are displayed in a page in the Home screen.
 Provides a list of shared properties and their attributes as they should consistently appear
 across subclasses.
 
 Subclasses must have their own XIB files where the Autolayout rules are completely defined,
 without warnings and errors. Dynamic heights are computed by instantiating a dummy cell from
 one of the subclass XIBs and then getting the wrapper view's height.
 */
class _HPVCChartCell: UICollectionViewCell {
    
    /// Wraps all of the cell's content. Its height is always the height of the content
    /// given the cell's width, and is always independent from the height of the cell itself.
    @IBOutlet weak var wrapperView: UIView!
    
    /// Displays the category name.
    @IBOutlet weak var nameLabel: UILabel!
    
    /// Displays the category total.
    @IBOutlet weak var totalLabel: UILabel!
    
    /// Displays the "No expenses" label.
    @IBOutlet weak var noExpensesLabel: UILabel!
    
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphBackgroundContainer: UIView!
    
    let graphBackground = GraphBackground.instantiateFromNib()
    
    var chartData: ChartData? {
        didSet {
            self.update(withData: chartData, drawGraph: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.graphContainer,
            self.graphBackgroundContainer,
            self.graphBackground
            )
        
        self.backgroundColor = UIColor.red
        self.wrapperView.backgroundColor = UIColor(hex: 0x333333)
        
        _HPVCChartCell.applyAttributes(toNameLabel: self.nameLabel)
        _HPVCChartCell.applyAttributes(toTotalLabel: self.totalLabel)
        _HPVCChartCell.applyAttributes(toNoExpensesLabel: self.noExpensesLabel)
        
        self.graphBackgroundContainer.addSubviewAndFill(self.graphBackground)
    }
    
    class func applyAttributes(toNameLabel label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.bold, 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    class func applyAttributes(toTotalLabel label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.regular, 17)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
    }
    
    class func applyAttributes(toNoExpensesLabel label: UILabel) {
        label.textColor = UIColor(hex: 0x666666)
        label.font = Font.make(.regular, 20)
        label.text = "No expenses"
    }
    
    /**
     Update the cell's subviews for the chart data. If the cell is being used for display,
     the second parameter should be `true`. If the cell is only a dummy that is being used
     for dynamic height computation, then the second parameter should be `false` to save resources.
     
     This function is meant to be overridden in the subclass but the subclass must always call super.
     */
    func update(withData chartData: ChartData?, drawGraph: Bool) {
        defer {
            self.setNeedsLayout()
        }
        
        guard let chartData = chartData
            else {
                return
        }
        
        self.nameLabel.text = chartData.category?.name
        self.totalLabel.text = AmountFormatter.displayText(for: chartData.categoryTotal)
    }
    
    public class func height(for chartData: ChartData, atCellWidth cellWidth: CGFloat) -> CGFloat {
        let dummyCell = self.instantiateFromNib()
        dummyCell.frame = CGRect(x: 0, y: 0, width: cellWidth, height: 0)
        dummyCell.update(withData: chartData, drawGraph: false)
        dummyCell.layoutIfNeeded()
        return dummyCell.wrapperView.bounds.size.height
    }
    
}
