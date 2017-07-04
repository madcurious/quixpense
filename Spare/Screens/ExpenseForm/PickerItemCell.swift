//
//  PickerItemCell.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class PickerItemCell: UITableViewCell {
    
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.checkboxImageView.image = UIImage.templateNamed("cellAccessoryItemUnchecked")
        self.checkImageView.image = UIImage.templateNamed("cellAccessoryItemChecked")
        self.checkImageView.isHidden = true
    }
    
    var isActive = false {
        didSet {
            self.checkImageView.isHidden = self.isActive == false
        }
    }
    
}

extension PickerItemCell: Themeable {
    
    func applyTheme() {
        self.sizerView.clearAllBackgroundColors()
        self.checkboxImageView.tintColor = Global.theme.color(for: .controlTint)
        self.checkImageView.tintColor = Global.theme.color(for: .checkImageView)
    }
    
}
