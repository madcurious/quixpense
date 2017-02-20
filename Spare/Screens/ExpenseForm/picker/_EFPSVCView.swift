//
//  _EFPSVCView.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFPSVCView: UIView, Themeable {
    
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableViewContainer: UIView!
    
    @IBOutlet weak var defaultTableView: UITableView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.textFieldContainer,
            self.tableViewContainer)
        
        self.textField.font = Font.regular(17)
        self.textField.autocapitalizationType = .sentences
        
        self.applyTheme()
        
        self.defaultTableView.separatorStyle = .none
        self.resultsTableView.separatorStyle = .none
    }
    
    func applyTheme() {
        self.textField.backgroundColor = Global.theme.pickerTextFieldBackgroundColor
        self.textField.textColor = Global.theme.pickerFieldValueTextColor
    }
    
}
