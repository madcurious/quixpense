//
//  __SVCCategoryCellBox.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kCategoryNameAttributes: [String : AnyObject] =  [
    NSForegroundColorAttributeName : Color.UniversalTextColor.CGColor,
    NSFontAttributeName : Font.make(.Book, 20)
]

private let kPercentAttributes: [String : AnyObject] = [
    NSForegroundColorAttributeName : Color.UniversalSecondaryTextColor.CGColor,
    NSFontAttributeName : Font.make(.Book, 20)
]

class __SVCCategoryCellBox: __SVCCategoryCell {
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override var data: (category: Category, total: NSDecimalNumber, percent: Double)? {
        didSet {
            guard let data = self.data
                else {
                    return
            }
            
            self.boxView.backgroundColor = data.category.color
            
            let nameLabelText = NSMutableAttributedString(string: "\(data.category.name!) ", attributes: kCategoryNameAttributes)
            nameLabelText.appendAttributedString(NSAttributedString(string: String(format: "(%.0f%%)", data.percent * 100), attributes: kPercentAttributes))
            self.nameLabel.attributedText =  nameLabelText
            
            self.totalLabel.text = AmountFormatter.displayTextForAmount(data.total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.wrapperView)
    }
    
}
