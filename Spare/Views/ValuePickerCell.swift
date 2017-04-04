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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkmarkImageView.image = UIImage.templateNamed("cellAccessoryCheckmark")
        self.checkmarkImageView.isHidden = true
        
        self.valueLabel.font = Font.regular(17)
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.checkmarkImageView.tintColor = Global.theme.color(for: .cellAccessoryIcon)
        self.valueLabel.textColor = Global.theme.color(for: .cellMainText)
    }
    
}
