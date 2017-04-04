//
//  ValuePickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 04/04/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ValuePickerCell: UITableViewCell, Themeable {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueLabelLeading: NSLayoutConstraint!
    
    var indexPath: IndexPath?
    var isChecked = false {
        didSet {
            self.checkmarkImageView.isHidden = self.isChecked == false
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkmarkImageView.image = UIImage.templateNamed("cellAccessoryCheckmark")
        self.checkmarkImageView.isHidden = true
        
        self.valueLabel.font = Global.theme.font(for: .regularText)
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.checkmarkImageView.tintColor = Global.theme.color(for: .cellAccessoryIcon)
        self.valueLabel.textColor = Global.theme.color(for: .cellMainText)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsetsMake(0, self.valueLabelLeading.constant, 0, 0)
    }
    
}
