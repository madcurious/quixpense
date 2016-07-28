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
    @IBOutlet weak var detailLabel: UILabel!
    
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
            self.categoryLabel.text = String(format: "%@ (%.0f%%)", categoryName, percent * 100)
            self.detailLabel.text = glb_displayTextForTotal(total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        self.categoryLabel.textColor = Color.UniversalTextColor
        self.categoryLabel.font = Font.SummaryCellCategoryLabel
        
        self.detailLabel.textColor = Color.UniversalTextColor
        self.detailLabel.font = Font.SummaryCellDetailLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.categoryLabel.text = nil
        self.detailLabel.text = nil
        self.stubView.backgroundColor = Color.UniversalBackgroundColor
    }
    
}
