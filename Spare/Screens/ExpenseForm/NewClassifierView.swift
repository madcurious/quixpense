//
//  NewClassifierView.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class NewClassifierView: UIView {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var separatorViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.promptLabel.text = "NAME"
        self.textField.autocapitalizationType = .sentences
    }
    
}

extension NewClassifierView: Themeable {
    
    func applyTheme() {
        self.clearAllBackgroundColors()
        
        self.backgroundColor = .groupTableViewBackground
        self.textFieldContainer.backgroundColor = Global.theme.color(for: .mainBackground)
        for separatorView in self.separatorViews {
            separatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
        
        self.promptLabel.font = Global.theme.font(for: .groupedTableViewSectionHeader)
        self.promptLabel.textColor = Global.theme.color(for: .groupedTableViewSectionHeader)
        
        self.textField.font = Global.theme.font(for: .regularText)
    }
    
}
