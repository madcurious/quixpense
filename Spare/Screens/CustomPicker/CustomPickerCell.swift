//
//  CustomPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerCell: UITableViewCell {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var itemLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var itemLabelTrailing: NSLayoutConstraint!
    
    static let ItemLabelLeading = CGFloat(36)
    static let ItemLabelTrailing = CGFloat(10)
    static let ItemLabelTop = CGFloat(10)
    static let ItemLabelBottom = CGFloat(10)
    
    static let sizerLabel: UILabel = {
        let label = UILabel()
        CustomPickerCell.applyItemLabelAttributes(label)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emptyView.backgroundColor = UIColor.clearColor()
        
        self.checkLabel.text = Icon.Check.rawValue
        self.checkLabel.textColor = Color.CustomPickerTextColor
        self.checkLabel.font = Font.icon(20)
        
        CustomPickerCell.applyItemLabelAttributes(self.itemLabel)
    }
    
    override func updateConstraints() {
        self.itemLabelLeading.constant = CustomPickerCell.ItemLabelLeading
        self.itemLabelTrailing.constant = CustomPickerCell.ItemLabelTrailing
        
        super.updateConstraints()
    }
    
    class func applyItemLabelAttributes(label: UILabel) {
        label.textColor = Color.CustomPickerTextColor
        label.font = Font.CustomPickerText
        label.numberOfLines = 3
        label.lineBreakMode = .ByTruncatingTail
    }
    
}
