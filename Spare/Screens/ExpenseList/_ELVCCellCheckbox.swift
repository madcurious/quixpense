//
//  _ELVCCellCheckbox.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _ELVCCellCheckbox: UIView, Themeable {
    
    @IBOutlet weak var boxImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.boxImageView.image = UIImage.templateNamed("_ELVCCellCheckboxBox")
        self.checkImageView.image = UIImage.templateNamed("_ELVCCellCheckboxCheck")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.boxImageView.tintColor = Global.theme.expenseListCellCheckboxColor
        self.checkImageView.tintColor = Global.theme.expenseListCellCheckColor
    }
    
}
