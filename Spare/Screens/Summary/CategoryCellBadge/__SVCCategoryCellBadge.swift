//
//  __SVCCategoryCellBadge.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCCategoryCellBadge: __SVCCategoryCell {
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            if let (category, total, percent) = self.info {
                self.badgeLabel.backgroundColor = category.color
                self.badgeLabel.text = "\(Int(percent * 100))%"
                
                self.categoryLabel.text = category.name
                self.totalLabel.text = glb_displayTextForTotal(total)
            } else {
                self.badgeLabel.backgroundColor = UIColor.clearColor()
                self.badgeLabel.text = nil
                self.categoryLabel.text = nil
                self.totalLabel.text = nil
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.applyHighlight(highlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.SummaryCellBadgeBackgroundColorDefault
        
        self.badgeLabel.adjustsFontSizeToFitWidth = true
        self.badgeLabel.font = Font.SummaryCellBadge
        self.badgeLabel.numberOfLines = 1
        self.badgeLabel.lineBreakMode = .ByClipping
        self.badgeLabel.textColor = Color.SummaryCellBadgeText
        self.badgeLabel.textAlignment = .Center
        self.badgeLabel.layer.cornerRadius = 4
        self.badgeLabel.clipsToBounds = true
        
        self.categoryLabel.font = Font.SummaryCellCategoryLabel
        self.categoryLabel.numberOfLines = 1
        self.categoryLabel.lineBreakMode = .ByTruncatingTail
        self.categoryLabel.textColor = Color.SummaryCellTextColor
        
        self.totalLabel.font = Font.SummaryCellTotalLabel
        self.totalLabel.numberOfLines = 1
        self.totalLabel.lineBreakMode = .ByClipping
        self.totalLabel.textColor = Color.SummaryCellTextColor
    }
    
    func applyHighlight(apply: Bool) {
        if apply {
            self.backgroundColor = Color.SummaryCellHighlightedColor
        } else {
            self.backgroundColor = Color.SummaryCellBadgeBackgroundColorDefault
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.size.width / 2
    }
    
}