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
    
    @IBOutlet weak var fullTableView: UITableView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.textFieldContainer,
            self.tableViewContainer)
        
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.autocapitalizationType = .sentences
        
        self.applyTheme()
        
        self.fullTableView.separatorStyle = .none
        self.resultsTableView.separatorStyle = .none
        self.resultsTableView.isHidden = true
        self.fullTableView.backgroundColor = UIColor.red
        self.resultsTableView.backgroundColor = UIColor.green
    }
    
    func applyTheme() {
        self.textField.backgroundColor = Global.theme.color(for: .pickerTextFieldBackground)
        self.textField.textColor = Global.theme.color(for: .pickerFieldValue)
    }
    
}
