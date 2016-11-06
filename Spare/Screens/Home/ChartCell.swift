//
//  ChartCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class ChartCell: UICollectionViewCell {
    
    var chartData: ChartData? {
        didSet {
            if let chartData = self.chartData {
                self.chartData = chartData
            }
        }
    }
    
    var mode = App.selectedPeriodization {
        didSet {
            switch mode {
            case .day:
                self.chartVC = self.dayChartVC
                
            default:
                fatalError("UNIMPLEMENTED")
            }
        }
    }
    
    lazy var dayChartVC: DayChartVC = DayChartVC()
    
    var chartVC = HomeChartVC() {
        didSet {
            oldValue.view.removeFromSuperview()
            self.contentView.addSubviewAndFill(self.chartVC.view)
        }
    }
    
    class func applyNameLabelAttributes(to label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Heavy, 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    class func applyTotalLabelAttributes(to label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Book, 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
    }
    
    class func height(for chartData: ChartData, atCellWidth cellWidth: CGFloat) -> CGFloat {
        return 150
    }
    
}
