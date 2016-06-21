//
//  __SVCCategoryCellPieChart.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCCategoryCellPieChart: __SVCCategoryCell {
    
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var pieChart: __SVCPieChart!
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (category, total, percent) = self.info
                else {
                    return
            }
            
            self.contentView.backgroundColor = category.color
            self.pieChart.percent = percent
            
            self.nameLabel.text = category.name
            self.totalLabel.text = glb_textForTotal(total)
            self.percentLabel.text = "\(Int(percent * 100))%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self.pieChartContainer, self.pieChart, self.labelContainer)
        
        self.nameLabel.textColor = Color.SummaryCellTextColorLight
        self.nameLabel.font = Font.SummaryCellNameLabel
        
        self.totalLabel.textColor = Color.SummaryCellTextColorLight
        self.totalLabel.font = Font.SummaryCellTotalLabel
        
        self.percentLabel.textColor = Color.SummaryCellTextColorLight
        self.percentLabel.font = Font.SummaryCellPercentLabel
    }
    
}
