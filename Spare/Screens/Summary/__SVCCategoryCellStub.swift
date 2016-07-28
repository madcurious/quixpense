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
            self.categoryLabel.text = categoryName
            self.detailLabel.text = String.init(format: "%@ (%.0f%%)", glb_displayTextForTotal(total), percent * 100)
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
