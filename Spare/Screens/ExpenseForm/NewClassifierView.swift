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
        applyTheme()
        
        headerLabel.text = "NAME"
        textField.autocapitalizationType = .sentences
        textField.clearButtonMode = .whileEditing
        
        footerLabel.numberOfLines = 0
        footerLabel.lineBreakMode = .byWordWrapping
    }
    
}

extension NewClassifierView: Themeable {
    
    func applyTheme() {
        clearAllBackgroundColors()
        
        backgroundColor = .groupTableViewBackground
        textFieldContainer.backgroundColor = Global.theme.color(for: .mainBackground)
        for separatorView in separatorViews {
            separatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
        
        headerLabel.font = Global.theme.font(for: .groupedTableViewSectionHeader)
        headerLabel.textColor = Global.theme.color(for: .groupedTableViewSectionHeader)
        
        textField.font = Global.theme.font(for: .regularText)
        
        footerLabel.font = Global.theme.font(for: .groupedTableViewSectionHeader)
        footerLabel.textColor = Global.theme.color(for: .groupedTableViewSectionFooter)
    }
    
}
