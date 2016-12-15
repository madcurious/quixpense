//
//  __HPVCWeekCell.swift
//  Spare
//
//  Created by Matt Quiros on 15/12/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HPVCWeekCell: __HPVCChartCell {
    
    @IBOutlet weak var dailyAverageLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet var weekdayLabels: [UILabel]!
    
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet var barViewContainers: [UIView]!
    @IBOutlet var barViews: [UIView]!
    
    @IBOutlet var dateLabels: [UILabel]!
    
    @IBOutlet var barWidths: [NSLayoutConstraint]!
    @IBOutlet var barHeights: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.barViewContainers)
        
        self.dailyAverageLabel.font = Font.make(.regular, 12)
        self.dailyAverageLabel.textColor = Color.UniversalTextColor
        self.dailyAverageLabel.numberOfLines = 1
        self.dailyAverageLabel.lineBreakMode = .byTruncatingTail
        
        self.percentLabel.font = Font.make(.regular, 12)
        self.percentLabel.textColor = Color.UniversalTextColor
        self.percentLabel.numberOfLines = 1
        self.percentLabel.lineBreakMode = .byTruncatingTail
        
        var accessoryLabels = weekdayLabels!
        accessoryLabels.append(contentsOf: dateLabels)
        for label in accessoryLabels {
            label.font = Font.make(.regular, 10)
            label.textColor = Color.UniversalTextColor
            label.textAlignment = .center
        }
        
        let barWidth = CGFloat(6)
        for i in 0 ..< 7 {
            self.barWidths[i].constant = barWidth
            
            self.barViews[i].backgroundColor = UIColor(hex: 0xd8d8d8)
            self.barViews[i].layer.cornerRadius = barWidth / 2
        }
    }
    
    override func update(withData chartData: ChartData?, drawGraph: Bool) {
        super.update(withData: chartData, drawGraph: drawGraph)
        
        guard let chartData = chartData
            else {
                return
        }
        
        self.dailyAverageLabel.text = "Daily average: \(AmountFormatter.displayText(for: chartData.dailyAverage))"
        self.percentLabel.text = PercentFormatter.displayText(for: chartData.ratio)
        
        for i in 0 ..< self.weekdayLabels.count {
            let label = self.weekdayLabels[i]
            label.text = chartData.weekdays?[i] ?? nil
        }
        
        for i in 0 ..< self.dateLabels.count {
            let label = self.dateLabels[i]
            label.text = chartData.dates?[i] ?? nil
        }
        
        guard drawGraph == true,
            let percentages = chartData.percentages
            else {
                return
        }
        
        if percentages.contains(where: { $0 > 0 }) {
            self.noExpensesLabel.isHidden = true
        } else {
            self.noExpensesLabel.isHidden = false
        }
        
        self.layoutIfNeeded()
        for i in 0 ..< 7 {
            self.barHeights[i].constant = self.barStackView.bounds.size.height * percentages[i]
        }
        self.setNeedsLayout()
    }
    
}
