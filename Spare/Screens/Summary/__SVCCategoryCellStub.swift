//
//  __SVCCategoryCellStub.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCCategoryCellStub: __SVCCategoryCell {
    
    @IBOutlet weak var stubView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override var info: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            guard let (category, total, percent) = self.info,
                let categoryName = category.name
                else {
                    return
            }
            self.stubView.backgroundColor = category.color
            self.categoryLabel.text = categoryName
            self.totalLabel.text = glb_displayTextForTotal(total)
            self.percentLabel.text = String(format: "(%.0f%%)", percent * 100)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        self.categoryLabel.textColor = Color.UniversalTextColor
        self.categoryLabel.font = Font.SummaryCellTextLabel
        self.categoryLabel.numberOfLines = 2
        self.categoryLabel.lineBreakMode = .ByTruncatingTail
        
        self.totalLabel.textColor = Color.UniversalTextColor
        self.totalLabel.font = Font.SummaryCellTextLabel
        
        self.percentLabel.textColor = Color.UniversalSecondaryTextColor
        self.percentLabel.font = Font.SummaryCellTextLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.categoryLabel.text = nil
        self.totalLabel.text = nil
        self.percentLabel.text = nil
        self.stubView.backgroundColor = Color.UniversalBackgroundColor
    }
    
}
