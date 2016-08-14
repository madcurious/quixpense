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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emptyView.backgroundColor = UIColor.clearColor()
        
        self.checkLabel.text = Icon.Check.rawValue
        self.checkLabel.textColor = Color.CustomPickerItemTextColor
        self.checkLabel.font = Font.icon(20)
        
        self.itemLabel.textColor = Color.CustomPickerItemTextColor
        self.itemLabel.font = Font.CustomPickerText
        self.itemLabel.numberOfLines = 3
        self.itemLabel.lineBreakMode = .ByTruncatingTail
    }
    
}
