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
            
            self.contentView.backgroundColor = category.color
            self.nameLabel.text = category.name
            self.totalLabel.text = glb_displayTextForTotal(total)
            self.percentLabel.text = "\(Int(percent * 100))%"
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.applyHighlight(self.highlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.labelContainer, self.stubView)
        
        self.nameLabel.font = Font.SummaryCellNameLabel
        self.totalLabel.font = Font.SummaryCellTotalLabel
        self.percentLabel.font = Font.SummaryCellPercentLabel
        
        self.nameLabel.textColor = Color.SummaryCellTextColorLight
        self.totalLabel.textColor = Color.SummaryCellTextColorLight
        self.percentLabel.textColor = Color.SummaryCellTextColorLight
        
        self.applyHighlight(false)
    }
    
    func applyHighlight(apply: Bool) {
        if apply {
            self.contentView.backgroundColor = Color.SummaryCellHighlightedColor
        } else {
            let categoryColor = self.info?.0.color ?? UIColor.blackColor()
            self.contentView.backgroundColor = categoryColor
        }
    }
    
}
