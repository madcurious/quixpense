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
    
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphBackgroundContainer: UIView!
    
    @IBOutlet var dateLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dailyAverageLabel.font = Font.make(.regular, 10)
        self.dailyAverageLabel.textColor = Color.UniversalTextColor
        self.dailyAverageLabel.numberOfLines = 1
        self.dailyAverageLabel.lineBreakMode = .byTruncatingTail
        
        self.percentLabel.font = Font.make(.regular, 10)
        self.percentLabel.textColor = Color.UniversalTextColor
        self.percentLabel.numberOfLines = 1
        self.percentLabel.lineBreakMode = .byTruncatingTail
        
        var accessoryLabels = weekdayLabels!
        accessoryLabels.append(contentsOf: dateLabels)
        for label in accessoryLabels {
            label.font = Font.make(.regular, 8)
            label.textColor = Color.UniversalTextColor
        }
    }
    
    override func update(forChartData chartData: ChartData?, includingGraph: Bool) {
        super.update(forChartData: chartData, includingGraph: includingGraph)
        
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
        
        if includingGraph == true {
            
        }
    }
    
}
