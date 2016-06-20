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
    
    @IBOutlet weak var colorBox: UIView!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (category, total, _) = self.info
                else {
                    return
            }
            
            self.colorBox.backgroundColor = category.color
            self.nameLabel.text = category.name
            
            self.totalLabel.text = glb_textForTotal(total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.labelContainer, self.nameLabel, self.totalLabel)
        
        self.contentView.backgroundColor = Color.SummaryCellBackgroundColor
        
        self.nameLabel.font = Font.SummaryCellNameLabel
        self.nameLabel.textColor = Color.SummaryCellTextColor
        
        self.totalLabel.font = Font.SummaryCellTotalLabel
        self.totalLabel.textColor = Color.SummaryCellTextColor
        
//        self.totalLabel.text = "$ 0.00"
    }
    
}