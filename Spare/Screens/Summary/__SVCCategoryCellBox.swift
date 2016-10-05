//
//  __SVCCategoryCellBox.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kNameLabelFont = Font.make(.Book, 20)

private let kCategoryNameAttributes: [String : AnyObject] =  [
    NSForegroundColorAttributeName : Color.UniversalTextColor.cgColor,
    NSFontAttributeName : kNameLabelFont
]

private let kPercentAttributes: [String : AnyObject] = [
    NSForegroundColorAttributeName : Color.UniversalSecondaryTextColor.cgColor,
    NSFontAttributeName : kNameLabelFont
]

class __SVCCategoryCellBox: __SVCCategoryCell {
    
    static let nameLabelTopBottom = CGFloat(8)
    static let boxViewWidth = CGFloat(12)
    static let boxViewTrailing = CGFloat(10)
    static let totalLabelLeading = CGFloat(4)
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var boxViewWidth: NSLayoutConstraint!
    @IBOutlet weak var boxViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTop: NSLayoutConstraint!
    @IBOutlet weak var nameLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var totalLabelLeading: NSLayoutConstraint!
    
    override var data: (Category, NSDecimalNumber, Double)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (category, total, percent) = self.data
                else {
                    return
            }
            
            self.boxView.backgroundColor = category.color
            self.nameLabel.attributedText = __SVCCategoryCellBox.attributedTextForCategoryName(category.name!, percent: percent)
            self.totalLabel.text = AmountFormatter.displayTextForAmount(total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.nameLabel,
            self.totalLabel
        )
//        self.backgroundColor = UIColor(hex: 0xcccccc)
        
        self.boxView.layer.cornerRadius = 2
        
        __SVCCategoryCellBox.applyNameLabelAttributesToLabel(self.nameLabel)
        __SVCCategoryCellBox.applyTotalLabelAttributesToLabel(self.totalLabel)
        
        // Update constraints.
        self.boxViewWidth.constant = __SVCCategoryCellBox.boxViewWidth
        self.boxViewTrailing.constant = __SVCCategoryCellBox.boxViewTrailing
        self.nameLabelTop.constant = __SVCCategoryCellBox.nameLabelTopBottom
        self.nameLabelBottom.constant = __SVCCategoryCellBox.nameLabelTopBottom
        self.totalLabelLeading.constant = __SVCCategoryCellBox.totalLabelLeading
    }
    
    class func applyNameLabelAttributesToLabel(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    class func applyTotalLabelAttributesToLabel(_ label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Heavy, 20)
        label.textAlignment = .right
    }
    
    class func attributedTextForCategoryName(_ categoryName: String, percent: Double) -> NSAttributedString {
        let text = NSMutableAttributedString(string: "\(categoryName) ", attributes: kCategoryNameAttributes)
        text.append(NSAttributedString(string: "(\(PercentFormatter.displayTextForPercent(percent)))", attributes: kPercentAttributes))
        return text
    }
    
    override class func cellHeightForData(_ data: (Category, NSDecimalNumber, Double), cellWidth: CGFloat) -> CGFloat {
        // Set the text for the total label.
        let totalLabel = UILabel()
        self.applyTotalLabelAttributesToLabel(totalLabel)
        totalLabel.text = AmountFormatter.displayTextForAmount(data.1)
        totalLabel.sizeToFit()
        
        let maxNameLabelWidth = cellWidth - (
            __SVCCategoryCellBox.boxViewWidth +
            __SVCCategoryCellBox.boxViewTrailing +
            __SVCCategoryCellBox.totalLabelLeading +
            totalLabel.bounds.size.width
        )
        
        let nameLabel = UILabel()
        self.applyNameLabelAttributesToLabel(nameLabel)
        
        nameLabel.attributedText = self.attributedTextForCategoryName(data.0.name!, percent: data.2)
        let nameLabelSize = nameLabel.sizeThatFits(CGSize(width: maxNameLabelWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let height = __SVCCategoryCellBox.nameLabelTopBottom * 2 + nameLabelSize.height
        return height
    }
    
}
