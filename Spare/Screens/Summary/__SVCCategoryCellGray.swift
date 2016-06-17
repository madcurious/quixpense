//
//  __SVCCategoryCellGray.swift
//  Spare
//
//  Created by Matt Quiros on 08/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCCategoryCellGray: __SVCCategoryCell {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override var total: NSDecimalNumber {
        didSet {
            self.totalLabel.text = String(format: "$ %.2f", self.total)
        }
    }
    
    override weak var category: Category? {
        didSet {
            if let category = self.category {
//                self.contentView.backgroundColor = category.color
                self.nameLabel.text = category.name
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.labelContainer, self.nameLabel, self.totalLabel)
        
        self.contentView.backgroundColor = Color.SummaryCellBackgroundColor
        
        self.nameLabel.font = Font.SummaryCellText
        self.nameLabel.textColor = Color.SummaryCellTextColor
        
        self.totalLabel.font = Font.SummaryCellText
        self.totalLabel.textColor = Color.SummaryCellTextColor
        
        self.totalLabel.text = "$ 0.00"
    }
    
}