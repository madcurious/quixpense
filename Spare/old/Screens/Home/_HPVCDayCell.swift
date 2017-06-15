//
//  _HPVCDayCell.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class _HPVCDayCell: _HPVCChartCell {
    
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var pieChartView: __HPVCPieChart!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.pieChartContainer,
            self.pieChartView
        )
        
        self.percentLabel.textColor = Color.UniversalTextColor
        self.percentLabel.font = Font.make(.regular, 14)
    }
    
    override func update(withData chartData: ChartData?, drawGraph: Bool) {
        super.update(withData: chartData, drawGraph: drawGraph)
        
        if drawGraph == true,
            let chartData = chartData {
            if chartData.categoryPercentage > 0 {
                self.percentLabel.text = PercentFormatter.displayText(for: chartData.categoryPercentage)
                self.pieChartView.percentage = chartData.categoryPercentage
                
                self.pieChartContainer.isHidden = false
                self.noExpensesLabel.isHidden = true
            } else {
                self.pieChartContainer.isHidden = true
                self.noExpensesLabel.isHidden = false
            }
        }
    }
    
}

class __HPVCPieChart: UIView {
    
    var percentage = CGFloat(0) {
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
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + (2 * CGFloat(M_PI) * self.percentage)
        
        let fillPath = UIBezierPath()
        fillPath.move(to: center)
        fillPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        fillPath.close()
        context.setFillColor(UIColor(hex: 0xd8d8d8).cgColor)
        fillPath.fill()
        
        let emptyPath = UIBezierPath()
        emptyPath.move(to: center)
        emptyPath.addArc(withCenter: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0x4e4e4e).cgColor)
        emptyPath.fill()
    }
    
}
