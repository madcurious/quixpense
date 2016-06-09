//
//  __SVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 08/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCCell: UICollectionViewCell {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var nameLabel: MDAspectFitLabel!
    @IBOutlet weak var totalLabel: MDAspectFitLabel!
    
    var total = NSDecimalNumber(integer: 0) {
        didSet {
            self.totalLabel.text = String(format: "$ %.2f", self.total)
        }
    }
    
    var percent = 0
    
    weak var category: Category? {
        didSet {
            if let category = self.category {
                self.contentView.backgroundColor = category.color
                self.nameLabel.text = category.name
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.labelContainer, self.nameLabel, self.totalLabel)
        
        self.nameLabel.font = Font.SummaryCellText
        self.totalLabel.font = Font.SummaryCellText
        
        self.nameLabel.textColor = Color.White
        self.totalLabel.textColor = Color.White
        
        self.totalLabel.text = "$ 0.00"
    }
    
}