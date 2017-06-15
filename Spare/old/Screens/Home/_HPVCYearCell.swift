//
//  _HPVCYearCell.swift
//  Spare
//
//  Created by Matt Quiros on 19/12/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kNumberOfMonthsInAYear = 12

class _HPVCYearCell: _HPVCChartCell {
    
    @IBOutlet weak var monthlyAverageLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var monthLabelContainer: UIView!
    
    var monthLabels = [UILabel]()
    var barViews = [_HPVCBarView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.monthLabelContainer)
        
        _HPVCChartCell.format(detailLabel: self.monthlyAverageLabel, alignment: .left)
        _HPVCChartCell.format(detailLabel: self.percentageLabel, alignment: .right)
        
        for i in 0 ..< kNumberOfMonthsInAYear {
            // Create the month labels.
            let monthLabel = UILabel()
            _HPVCChartCell.format(accessoryLabel: monthLabel)
            monthLabel.text = "\(i + 1)"
            self.monthLabels.append(monthLabel)
            self.monthLabelContainer.addSubview(monthLabel)
            
            // Add top and bottom constraints to the month labels.
            monthLabel.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                NSLayoutConstraint(item: monthLabel,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self.monthLabelContainer,
                                   attribute: .top,
                                   multiplier: 1,
                                   constant: 0),
                NSLayoutConstraint(item: monthLabel,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self.monthLabelContainer,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 0)
            ]
            self.monthLabelContainer.addConstraints(constraints)
            
            // Create the bar views.
            let barView = _HPVCBarView()
            self.barViews.append(barView)
            self.barStackView.addArrangedSubview(barView)
            
            // Center the month label to the bar view.
            let centerX =  NSLayoutConstraint(item: monthLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: barView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)
            self.wrapperView.addConstraint(centerX)
        }
    }
    
    override func update(withData chartData: ChartData?, drawGraph: Bool) {
        defer {
            self.setNeedsLayout()
        }
        
        super.update(withData: chartData, drawGraph: drawGraph)
        
        guard let chartData = chartData
            else {
                return
        }
        
        self.monthlyAverageLabel.text = "Monthly average: \(AmountFormatter.displayText(for: chartData.monthlyAverage))"
        self.percentageLabel.text = "\(PercentFormatter.displayText(for: chartData.categoryPercentage)) of total"
        
        guard drawGraph == true,
            let percentages = chartData.monthlyPercentages,
            percentages.contains(where: {$0 > 0})
            else {
                self.noExpensesLabel.isHidden = false
                return
        }
        
        self.noExpensesLabel.isHidden = true
        
        for i in 0 ..< kNumberOfMonthsInAYear {
            self.barViews[i].height = self.barStackView.bounds.size.height * percentages[i]
        }
    }
    
}
