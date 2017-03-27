//
//  NewFilterCell.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class NewFilterCell: UITableViewCell, Themeable {
    
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryImageView.image = UIImage.templateNamed("cellAccessoryAdd")
        
        self.promptLabel.font = Font.regular(17)
        self.promptLabel.text = "New filter"
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.accessoryImageView.tintColor = Global.theme.color(for: .cellAccessoryIcon)
        self.promptLabel.textColor = Global.theme.color(for: .commonCellMainText)
    }
    
}
