//
//  __HPVCDayCell.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate let kPadding = CGFloat(10)
fileprivate let kLabelSpacing = CGFloat(6)
fileprivate let kGraphContainerHeight = CGFloat(150)

class __HPVCDayCell: __HPVCSummaryCell {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphBackgroundContainer: UIView!
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var pieChartView: __HPVCPieChart!
    @IBOutlet weak var percentageLabel: UILabel!
    
    let graphBackground = __HPVCGraphBackground.instantiateFromNib()
    
    @IBOutlet var paddings: [NSLayoutConstraint]!
    @IBOutlet weak var labelSpacing: NSLayoutConstraint!
    @IBOutlet weak var graphContainerHeight: NSLayoutConstraint!
    
    override var summary: Summary? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            self.nameLabel.text = self.summary?.category.name
            self.totalLabel.text = AmountFormatter.displayTextForAmount(self.summary?.total)
            self.pieChartView.percentage = self.summary?.percentage ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.graphContainer,
            self.graphBackgroundContainer,
            self.graphBackground,
            self.pieChartContainer
        )
        
        self.graphBackgroundContainer.addSubviewAndFill(self.graphBackground)
        
        self.wrapperView.backgroundColor = UIColor(hex: 0x333333)
        
        __HPVCSummaryCell.applyAttributesToNameLabel(self.nameLabel)
        __HPVCSummaryCell.applyAttributesTotalLabel(self.totalLabel)
        
        for padding in self.paddings {
            padding.constant = kPadding
        }
        self.graphContainerHeight.constant = kGraphContainerHeight
        self.labelSpacing.constant = kLabelSpacing
    }
    
    override class func height(for summary: Summary, atCellWidth cellWidth: CGFloat) -> CGFloat {
        let totalLabel = UILabel()
        __HPVCSummaryCell.applyAttributesTotalLabel(totalLabel)
        totalLabel.text = AmountFormatter.displayTextForAmount(summary.total)
        totalLabel.sizeToFit()
        
        let nameLabel = UILabel()
        __HPVCSummaryCell.applyAttributesToNameLabel(nameLabel)
        nameLabel.text = summary.category.name
        let nameLabelWidth = cellWidth - (kPadding * 2 + kLabelSpacing + totalLabel.bounds.size.width)
        let nameLabelHeight = nameLabel.sizeThatFits(CGSize(width: nameLabelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        let height = kPadding + nameLabelHeight + kPadding + kGraphContainerHeight + kPadding
        return height
    }
    
}

class __HPVCPieChart: UIView {
    
    var percentage = 0.0 {
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
        let endAngle = startAngle + CGFloat(2 * M_PI * self.percentage)
        
        let fillPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0xd8d8d8).cgColor)
        fillPath.fill()
        
        let emptyPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0x4e4e4e).cgColor)
        emptyPath.fill()
    }
    
}
