//
//  _ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _ELVCCell: UITableViewCell, Themeable {
    
    var expense: Expense? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var checkboxContainer: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    let checkbox = _ELVCCellCheckbox.instantiateFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.wrapperView, self.checkboxContainer)
        
        self.checkboxContainer.addSubviewsAndFill(self.checkbox)
        
        self.amountLabel.font = Font.regular(17)
        self.amountLabel.textAlignment = .left
        self.amountLabel.numberOfLines = 1
        self.amountLabel.lineBreakMode = .byTruncatingTail
        
        self.detailLabel.font = Font.regular(14)
        self.detailLabel.textAlignment = .right
        self.detailLabel.numberOfLines = 1
        self.detailLabel.lineBreakMode = .byTruncatingTail
        
        self.disclosureIndicatorImageView.image = UIImage.templateNamed("disclosureIndicator")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.checkbox.applyTheme()
        self.disclosureIndicatorImageView.tintColor = Global.theme.disclosureIndicatorColor
    }
    
}
