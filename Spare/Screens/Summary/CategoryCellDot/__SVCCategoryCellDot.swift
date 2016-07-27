//
//  __SVCCategoryCellDot.swift
//  Spare
//
//  Created by Matt Quiros on 27/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCCategoryCellDot: __SVCCategoryCell {
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            if let (category, total, percent) = self.info,
                categoryName = category.name {
                self.dotView.backgroundColor = category.color
                self.categoryLabel.text = "\(categoryName)"
                self.valueLabel.text = "\(glb_displayTextForTotal(total)) (\(Int(percent * 100))%)"
            } else {
                self.dotView.backgroundColor = UIColor.clearColor()
                self.categoryLabel.text = nil
                self.valueLabel.text = nil
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
        
        self.categoryLabel.numberOfLines = 1
        self.categoryLabel.lineBreakMode = .ByTruncatingTail
        self.categoryLabel.font = Font.SummaryCellCategoryLabel
        self.categoryLabel.textColor = Color.SummaryCellTextColor
        self.categoryLabel.textAlignment = .Left
        
        self.valueLabel.font = Font.SummaryCellTotalLabel
        self.valueLabel.textColor = Color.SummaryCellTextColor
        self.valueLabel.textAlignment = .Right
        self.valueLabel.numberOfLines = 1
        self.valueLabel.lineBreakMode = .ByClipping
        
        self.applyHighlight(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dotView.layer.cornerRadius = self.dotView.bounds.size.width / 2
    }
    
    func applyHighlight(apply: Bool) {
        if apply {
            self.backgroundColor = Color.SummaryCellHighlightedColor
        } else {
            self.backgroundColor = Color.SummaryCellBackgroundColor
        }
    }
    
}
