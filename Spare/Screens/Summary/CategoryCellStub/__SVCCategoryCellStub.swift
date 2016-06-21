//
//  __SVCCategoryCellStub.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCCategoryCellStub: __SVCCategoryCell {
    
    @IBOutlet weak var stubView: UIView!
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (category, total, percent) = self.info
                else {
                    return
            }
            
            self.stubView.backgroundColor = category.color
            self.nameLabel.text = category.name
            self.totalLabel.text = glb_textForTotal(total)
            self.percentLabel.text = "\(Int(percent * 100))%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.labelContainer)
        self.contentView.backgroundColor = Color.SummaryCellBackgroundColor
        
        self.nameLabel.font = Font.SummaryCellNameLabel
        self.nameLabel.textColor = Color.SummaryCellTextColor
        
        self.totalLabel.font = Font.SummaryCellTotalLabel
        self.totalLabel.textColor = Color.SummaryCellTextColor
        
        self.percentLabel.font = Font.SummaryCellPercentLabel
        self.percentLabel.textColor = Color.SummaryCellTextColor
    }
}
