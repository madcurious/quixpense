//
//  __EEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 03/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __EEVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var fieldBoxes: [UIView]!
    @IBOutlet var fieldLabels: [UILabel]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paidWithControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background colors.
        self.backgroundColor = Color.Gray1
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        // Setup labels.
        let texts = ["NAME", "AMOUNT", "CATEGORY", "DATE SPENT", "PAID WITH"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textColor = Color.Gray7
            label.font = Font.FieldLabel
            label.text = texts[i]
        }
        
        // Setup text fields.
        let textFields = [self.nameTextField, self.amountTextField]
        for textField in textFields {
            textField.font = Font.FieldValue
            textField.textColor = Color.Black
            textField.placeholder = Strings.FieldPlaceholder
            textField.adjustsFontSizeToFitWidth = false
        }
        
        // Setup buttons.
        let buttons = [self.categoryButton, self.dateButton]
        let titles = ["Food and Beverage", "Today, 4 PM"]
        let attributes = [
            NSForegroundColorAttributeName : Color.Black,
            NSFontAttributeName: Font.FieldValue
        ]
        for i in 0..<buttons.count {
            let button = buttons[i]
            button.setAttributedTitle(NSAttributedString(string: titles[i], attributes: attributes), forState: .Normal)
            button.contentHorizontalAlignment = .Left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 10)
        }
        
        // Setup segmented control.
        let paymentMethods = ["CASH", "CREDIT", "DEBIT"]
        for i in 0..<paymentMethods.count {
            let title = paymentMethods[i]
            self.paidWithControl.setTitle(title, forSegmentAtIndex: i)
        }
        self.paidWithControl.setTitleTextAttributes([NSFontAttributeName: Font.FieldLabel], forState: .Normal)
        self.paidWithControl.tintColor = Color.Black
    }
    
}
