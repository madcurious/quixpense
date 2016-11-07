//
//  __DCVCView.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

fileprivate let kPadding = CGFloat(10)
fileprivate let kLabelSpacing = CGFloat(6)
fileprivate let kGraphContainerHeight = CGFloat(120)

class __DCVCView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphBackgroundContainer: UIView!
    let graphBackground = GraphBackground.instantiateFromNib()
    
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet var paddings: [NSLayoutConstraint]!
    @IBOutlet weak var labelSpacing: NSLayoutConstraint!
    @IBOutlet weak var graphContainerHeight: NSLayoutConstraint!
    
    var chartData: ChartData? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let chartData = self.chartData
                else {
                    return
            }
            
            // Always set the category name.
            self.nameLabel.text = chartData.category.name
            
            switch (chartData.dateRangeTotal, chartData.categoryTotal, chartData.percent) {
            case (0, _, _),
                 (_, .some, _) where chartData.categoryTotal == 0:
                self.totalLabel.text = AmountFormatter.displayText(for: 0)
                self.percentLabel.text = PercentFormatter.displayTextForPercent(0)
                self.emptyLabel.isHidden = false
                self.pieChartContainer.isHidden = true
                
            case (_, nil, nil):
                self.totalLabel.text = "..."
                self.percentLabel.text = "..."
                self.emptyLabel.isHidden = true
                self.pieChartContainer.isHidden = true
                
            case (_, .some(let categoryTotal), .some(let percent)) where categoryTotal > 0:
                self.totalLabel.text = AmountFormatter.displayText(for: categoryTotal)
                self.percentLabel.text = PercentFormatter.displayTextForPercent(percent)
                
                self.pieView.percent = percent
                self.emptyLabel.isHidden = true
                self.pieChartContainer.isHidden = false
                
            default: ()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.graphContainer,
            self.graphBackgroundContainer,
            self.graphBackground,
            self.pieChartContainer,
            self.pieView
        )
        self.backgroundColor = UIColor(hex: 0x333333)
        
        HomeChartVC.applyAttributes(toNameLabel: self.nameLabel)
        HomeChartVC.applyAttributes(toTotalLabel: self.totalLabel)
        
        self.graphBackgroundContainer.addSubviewAndFill(self.graphBackground)
        
        self.emptyLabel.text = "No expenses"
        
        self.percentLabel.textColor = Color.UniversalTextColor
        self.percentLabel.font = Font.make(.Book, 14)
        
        for padding in self.paddings {
            padding.constant = kPadding
        }
        self.graphContainerHeight.constant = kGraphContainerHeight
        self.labelSpacing.constant = kLabelSpacing
    }
    
    class func height(for chartData: ChartData, atCellWidth cellWidth: CGFloat) -> CGFloat {
        let totalLabel = UILabel()
        HomeChartVC.applyAttributes(toTotalLabel: totalLabel)
        totalLabel.text = AmountFormatter.displayText(for: chartData.dateRangeTotal)
        totalLabel.sizeToFit()
        
        let nameLabel = UILabel()
        HomeChartVC.applyAttributes(toNameLabel: nameLabel)
        nameLabel.text = chartData.category.name
        let nameLabelWidth = cellWidth - (kPadding * 2 + kLabelSpacing + totalLabel.bounds.size.width)
        let nameLabelHeight = nameLabel.sizeThatFits(CGSize(width: nameLabelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        let height = kPadding + nameLabelHeight + kPadding + kGraphContainerHeight + kPadding
        return height
    }
    
}

class PieView: UIView {
    
    var percent = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
            else {
                return
        }
        
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let insetRect = rect.insetBy(dx: 1, dy: 1)
        let radius = insetRect.height / 2
        let startAngle = CGFloat(M_PI_2)
        let endAngle = startAngle + CGFloat(2 * M_PI * self.percent)
        
        let fillPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0xd8d8d8).cgColor)
        fillPath.fill()
        
        let emptyPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0x4e4e4e).cgColor)
        emptyPath.fill()
    }
    
}
