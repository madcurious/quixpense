//
//  __CategoryPickerVCView.swift
//  Spare
//
//  Created by Matt Quiros on 19/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __CategoryPickerVCView: CustomPickerView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let textFieldFont = Font.make(.Medium, 17)
        self.textField.backgroundColor = UIColor.clear
        self.textField.font = textFieldFont
        self.textField.textColor = UIColor.black
        self.textField.attributedPlaceholder = NSAttributedString(string: "Type a category", font: textFieldFont, textColor: UIColor(hex: 0xcccccc))
        self.textField.adjustsFontSizeToFitWidth = false
        self.textField.autocapitalizationType = .sentences
        
        self.borderView.backgroundColor = UIColor(hex: 0xcccccc)
        self.borderViewHeight.constant = 0.5
        
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.separatorStyle = .none
    }
    
}
