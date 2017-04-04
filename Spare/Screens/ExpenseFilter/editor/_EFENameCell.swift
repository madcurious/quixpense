//
//  _EFENameCell.swift
//  Spare
//
//  Created by Matt Quiros on 28/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFENameCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.nameTextField.font = Global.theme.font(for: .regularText)
        self.nameTextField.textColor = Global.theme.color(for: .textFieldValue)
        self.nameTextField.autocapitalizationType = .words
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.contentView.frame.contains(point) {
            return self.nameTextField
        }
        return super.hitTest(point, with: event)
    }
    
}
