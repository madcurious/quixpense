//
//  SlideUpPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class SlideUpPickerCell: UITableViewCell {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var itemLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var itemLabelTrailing: NSLayoutConstraint!
    
    static let ItemLabelLeading = CGFloat(36)
    static let ItemLabelTrailing = CGFloat(10)
    static let ItemLabelTop = CGFloat(10)
    static let ItemLabelBottom = CGFloat(10)
    
    var isChecked = false {
        didSet {
            self.checkLabel.isHidden = self.isChecked == false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emptyView.backgroundColor = UIColor.clear
        
        self.checkLabel.text = Icon.Check.rawValue
        self.checkLabel.textColor = Color.CustomPickerTextColor
        self.checkLabel.font = Font.makeIcon(size: 14)
        self.checkLabel.isHidden = true
        
        SlideUpPickerCell.applyItemLabelAttributes(self.itemLabel)
    }
    
    override func updateConstraints() {
        self.itemLabelLeading.constant = SlideUpPickerCell.ItemLabelLeading
        self.itemLabelTrailing.constant = SlideUpPickerCell.ItemLabelTrailing
        
        super.updateConstraints()
    }
    
    class func applyItemLabelAttributes(_ label: UILabel) {
        label.textColor = Color.CustomPickerTextColor
        label.font = Font.CustomPickerText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
}
