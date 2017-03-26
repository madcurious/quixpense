//
//  ExpenseFilterCell.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseFilterCell: UITableViewCell, Themeable {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButtonTapArea: UIView!
    @IBOutlet weak var editButton: MDImageButton!
    
    @IBOutlet weak var nameLabelLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkmarkImageView.image = UIImage.templateNamed("cellAccessoryCheckmark")
        
        self.nameLabel.font = Font.regular(17)
        self.nameLabel.numberOfLines = 1
        self.nameLabel.lineBreakMode = .byTruncatingTail
        
        self.editButtonTapArea.backgroundColor = UIColor.clear
        
        self.editButton.image = UIImage.templateNamed("cellAccessoryEdit")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.checkmarkImageView.tintColor = Global.theme.color(for: .commonCellCheckmark)
        self.nameLabel.textColor = Global.theme.color(for: .commonCellMainText)
        self.editButton.tintColor = Global.theme.color(for: .commonCellImageButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets(top: 0, left: self.nameLabelLeading.constant, bottom: 0, right: 0)
    }
    
}
