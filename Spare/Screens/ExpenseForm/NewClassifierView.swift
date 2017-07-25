//
//  NewClassifierView.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class NewClassifierView: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var separatorViews: [UIView]!
    @IBOutlet weak var footerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.headerLabel.text = "NAME"
        self.textField.autocapitalizationType = .sentences
        
        self.footerLabel.numberOfLines = 0
        self.footerLabel.lineBreakMode = .byWordWrapping
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
        
        self.headerLabel.font = Global.theme.font(for: .groupedTableViewSectionHeader)
        self.headerLabel.textColor = Global.theme.color(for: .groupedTableViewSectionHeader)
        
        self.textField.font = Global.theme.font(for: .regularText)
        
        self.footerLabel.font = Global.theme.font(for: .groupedTableViewSectionHeader)
        self.footerLabel.textColor = Global.theme.color(for: .groupedTableViewSectionFooter)
    }
    
}
