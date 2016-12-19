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
        
        _HPVCChartCell.format(nameLabel: self.nameLabel)
        _HPVCChartCell.format(totalLabel: self.totalLabel)
        _HPVCChartCell.format(noExpensesLabel: self.noExpensesLabel)
        
        self.graphBackgroundContainer.addSubviewAndFill(self.graphBackground)
    }
    
    class func format(nameLabel: UILabel) {
        nameLabel.textColor = Color.UniversalTextColor
        nameLabel.font = Font.make(.bold, 17)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
    }
    
    class func format(totalLabel: UILabel) {
        totalLabel.textColor = Color.UniversalTextColor
        totalLabel.font = Font.make(.regular, 17)
        totalLabel.numberOfLines = 1
        totalLabel.lineBreakMode = .byTruncatingTail
    }
    
    class func format(noExpensesLabel: UILabel) {
        noExpensesLabel.textColor = UIColor(hex: 0x666666)
        noExpensesLabel.font = Font.make(.regular, 20)
        noExpensesLabel.text = "No expenses"
    }
    
    /**
     Applies formatting to detail labels, which are only available in week, month, and year cells.
     Detail labels display either a daily or a monthly average, and the `categoryPercentage`.
     */
    class func format(detailLabel: UILabel, alignment: NSTextAlignment) {
        detailLabel.font = Font.make(.regular, 12)
        detailLabel.textColor = Color.UniversalTextColor
        detailLabel.numberOfLines = 1
        detailLabel.lineBreakMode = .byTruncatingTail
        detailLabel.textAlignment = alignment
    }
    
    /**
     Applies formatting to accessory labels. Accessory labels are only present in week, month, and year
     cells and display dates or months under the graph, or days of the week over the graph.
     */
    class func format(accessoryLabel: UILabel) {
        accessoryLabel.font = Font.make(.regular, 11)
        accessoryLabel.textColor = Color.UniversalTextColor
        accessoryLabel.textAlignment = .center
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
