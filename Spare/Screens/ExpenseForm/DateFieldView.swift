//
//  DateFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 17/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class DateFieldView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: DateFieldViewTextField!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM yyyy, h:mm a"
        return formatter
    }()
    
    private lazy var datePicker = UIDatePicker(frame: .zero)
    
    var selectedDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearAllBackgroundColors()
        self.setDate(Date())
        
        self.imageView.image = UIImage.templateNamed("dateIcon")
        
        self.textField.isUserInteractionEnabled = false
        self.textField.inputView = self.datePicker
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnViewArea))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.datePicker.addTarget(self, action: #selector(handleValueChangeOnDatePicker), for: .valueChanged)
        
        self.applyTheme()
    }
    
    func setDate(_ date: Date) {
        self.selectedDate = date
        self.textField.text = self.dateFormatter.string(from: date)
    }
    
    @objc func handleValueChangeOnDatePicker() {
        self.setDate(self.datePicker.date)
    }
    
    @objc func handleTapOnViewArea() {
        self.datePicker.date = self.selectedDate
        self.textField.becomeFirstResponder()
    }
    
}

extension DateFieldView: Themeable {
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.textColor = Global.theme.color(for: .regularText)
    }
    
}

class DateFieldViewTextField: UITextField {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        // Hides the cursor even when the text field is active.
        return .zero
    }
    
}
