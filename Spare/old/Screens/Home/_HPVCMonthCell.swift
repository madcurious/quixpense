//
//  _HPVCMonthCell.swift
//  Spare
//
//  Created by Matt Quiros on 16/12/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kCenterConstraintID = "kCenterConstraintID"

/**
 Custom cell for the monthly view. The views that display the bars are added programatically in `awakeFromNib`
 because they're quite a lot, and it's easier to change them all at once in code than in XIB.
 
 There are always 31 bars, the last three of which are hidden or shown depending on the number of days
 in the month. There are always five date labels as well, from the 1st of the month and every 7 days.
 The label for the 29th day is shown or hidden depending on whether there is a 29th day in the month.
 The date labels are also center-aligned to their respective bars.
 */
class _HPVCMonthCell: _HPVCChartCell {
    
    @IBOutlet weak var dailyAverageLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var barStackView: UIStackView!
    
    @IBOutlet weak var dateLabelContainer: UIView!
    @IBOutlet var dateLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabelContainer.backgroundColor = UIColor.clear
        
        _HPVCChartCell.format(detailLabel: self.dailyAverageLabel, alignment: .left)
        _HPVCChartCell.format(detailLabel: self.percentageLabel, alignment: .right)
        
        var date = 1
        for label in self.dateLabels {
            _HPVCChartCell.format(accessoryLabel: label)
            label.text = "\(date)"
            date += 7
        }
        
        // Programatically add 31 bar views because doing this in code is easier to change than if done via XIB.
        //
        for _ in 0 ..< 31 {
            let barView = _HPVCBarView()
            self.barStackView.addArrangedSubview(barView)
        }
        
        let dates = [1, 8, 15, 22, 29]
        for i in 0 ..< dates.count {
            let label = self.dateLabels[i]
            label.text = "\(dates[i])"
            let centerX = NSLayoutConstraint(item: label,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.barStackView.arrangedSubviews[dates[i] - 1],
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
            self.wrapperView.addConstraint(centerX)
        }
    }
    
    override func update(withData chartData: ChartData?, drawGraph: Bool) {
        super.update(withData: chartData, drawGraph: drawGraph)
        
        guard let chartData = chartData
            else {
                return
        }
        
        self.dailyAverageLabel.text = "Daily average: \(AmountFormatter.displayText(for: chartData.dailyAverage))"
        self.percentageLabel.text = "\(PercentFormatter.displayText(for: chartData.categoryPercentage)) of total"
        
        guard drawGraph == true,
            let percentages = chartData.dailyPercentages,
            percentages.contains(where: { $0 > 0 })
            else {
                self.noExpensesLabel.isHidden = false
                return
        }
        
        self.noExpensesLabel.isHidden = true
        
        // Hide or show the last 3 bar views (29, 30, 31) if they are more
        // than the number of days in the month.
        for i in 28 ..< self.barStackView.arrangedSubviews.count {
            if i < percentages.count {
                self.barStackView.arrangedSubviews[i].isHidden = false
            } else {
                self.barStackView.arrangedSubviews[i].isHidden = true
            }
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        for i in 0 ..< percentages.count {
            let barView = self.barStackView.arrangedSubviews[i] as! _HPVCBarView
            let percentage = percentages[i]
            barView.height = self.barStackView.bounds.size.height * percentage
        }
        
        if percentages.count >= 29 {
            self.dateLabels.last?.isHidden = false
        } else {
            self.dateLabels.last?.isHidden = true
        }
        
        self.setNeedsLayout()
    }
    
}

