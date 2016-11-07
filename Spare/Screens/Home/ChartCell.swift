//
//  ChartCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class ChartCell: UICollectionViewCell {
    
    var data: (chartData: ChartData, mode: Periodization)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let data = self.data
                else {
                    return
            }
            
            switch data.mode {
            case .day:
                self.chartVC = self.dayChartVC
                
            default:
                fatalError("UNIMPLEMENTED")
            }
            
            self.chartVC.chartData = data.chartData
        }
    }
    
    lazy var dayChartVC: DayChartVC = DayChartVC()
    
    var chartVC = HomeChartVC() {
        didSet {
            oldValue.view.removeFromSuperview()
            self.contentView.addSubviewAndFill(self.chartVC.view)
        }
    }
    
    class func height(for chartData: ChartData, atCellWidth cellWidth: CGFloat) -> CGFloat {
        switch App.selectedPeriodization {
        case .day:
            return __DCVCView.height(for: chartData, atCellWidth: cellWidth)
            
        default:
            return 120
        }
    }
    
}
