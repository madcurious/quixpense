//
//  NewClassifierTextFieldCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class NewClassifierTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.selectionStyle = .none
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.frame.contains(point) {
            return self.textField
        }
        return super.hitTest(point, with: event)
    }
    
}

extension NewClassifierTextFieldCell: Themeable {
    
    func applyTheme() {
        self.textField.font = Global.theme.font(for: .regularText)
    }
    
}
