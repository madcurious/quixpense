//
//  __TSVCCategoryCell.swift
//  Spare
//
//  Created by Matt Quiros on 27/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __TSVCCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (category, total, percent) = self.info,
                let categoryName = category.name
                else {
                    self.nameLabel.text = nil
                    self.totalLabel.text = nil
                    self.percentLabel.text = nil
                    self.backgroundColor = UIColor.whiteColor()
                    return
            }
            
            self.nameLabel.text = categoryName
            self.totalLabel.text = glb_displayTextForTotal(total)
            self.percentLabel.text = String(format: "%.0f%%", percent * 100)
            self.backgroundColor = category.color
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.applyHighlight(self.highlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.numberOfLines = 4
        self.nameLabel.lineBreakMode = .ByClipping
        self.nameLabel.textColor = Color.TiledSummaryCellTextColor
        self.nameLabel.font = Font.TiledSummaryCellNameLabel
        
        self.totalLabel.numberOfLines = 1
        self.totalLabel.font = Font.TiledSummaryCellTotalLabel
        self.totalLabel.textColor = Color.TiledSummaryCellTextColor
        self.totalLabel.adjustsFontSizeToFitWidth = true
        
        self.percentLabel.textColor = Color.TiledSummaryCellTextColor
        self.percentLabel.font = Font.TiledSummaryCellPercentLabel
        self.percentLabel.numberOfLines = 1
        self.percentLabel.lineBreakMode = .ByClipping
        self.percentLabel.textAlignment = .Right
    }
    
    func applyHighlight(apply: Bool) {
        let labels = [self.nameLabel, self.totalLabel, self.percentLabel]
        if apply {
            self.backgroundColor = Color.TiledSummaryCellBackgroundColorHighlighted
            for label in labels {
                label.textColor = Color.TiledSummaryCellTextColorHighlighted
            }
        } else {
            self.backgroundColor = self.info?.0.color
            for label in labels {
                label.textColor = Color.TiledSummaryCellTextColor
            }
        }
    }
    
    
}