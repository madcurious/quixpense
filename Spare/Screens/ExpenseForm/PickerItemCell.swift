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
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
}

extension PickerItemCell: Themeable {
    
    func applyTheme() {
        self.sizerView.clearAllBackgroundColors()
    }
    
}
