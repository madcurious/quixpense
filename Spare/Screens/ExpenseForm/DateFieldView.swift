//
//  DateFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class DateFieldView: UIView, Themeable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fieldStackView: UIStackView!
    
    @IBOutlet weak var dayContainer: UIView!
    @IBOutlet weak var dayTextField: DateTextField!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthContainer: UIView!
    @IBOutlet weak var monthTextField: DateTextField!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var yearTextField: DateTextField!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet var textFields: [DateTextField]!
    @IBOutlet var textFieldLabels: [UILabel]!
    @IBOutlet var slashLabels: [UILabel]!
    
    let invalidCharacterSet = CharacterSet.wholeNumberCharacterSet().inverted
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.imageView.image = UIImage.templateNamed("dateIcon")
        
        self.dayLabel.text = "DD"
        self.monthLabel.text = "MM"
        self.yearLabel.text = "YYYY"
        for slashLabel in self.slashLabels {
            slashLabel.text = "/"
        }
        
        for textField in self.textFields {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleTextDidChangeNotification(_:)),
                name: Notification.Name.UITextFieldTextDidChange,
                object: textField)
            textField.delegate = self
            textField.dateTextFieldDelegate = self
            textField.keyboardType = .numberPad
        }
        
        self.setDate(Date())
    }
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        
        for textField in self.textFields {
            textField.font = Global.theme.font(for: .regularText)
            textField.textColor = Global.theme.color(for: .regularText)
            textField.textAlignment = .center
        }
        self.dayTextField.attributedPlaceholder = NSAttributedString(
            string: "31",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        self.monthTextField.attributedPlaceholder = NSAttributedString(
            string: "12",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        self.yearTextField.attributedPlaceholder = NSAttributedString(
            string: "1990",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        
        for slashLabel in self.slashLabels {
            slashLabel.font = Global.theme.font(for: .regularText)
            slashLabel.textColor = Global.theme.color(for: .regularText)
        }
        
        for textFieldLabel in self.textFieldLabels {
            textFieldLabel.font = Global.theme.font(for: .dateTextFieldLabel)
            textFieldLabel.textColor = Global.theme.color(for: .placeholder)
            textFieldLabel.textAlignment = .center
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Tapping on the year and the month stack views activate their corresponding text fields.
        // Tapping on anywhere else activates the day text field.
        let convertedPoint = self.convert(point, to: self.fieldStackView)
        switch convertedPoint {
        case _ where self.yearContainer.frame.contains(convertedPoint):
            return self.yearTextField
        case _ where self.monthContainer.frame.contains(convertedPoint):
            return self.monthTextField
        case _ where self.frame.contains(point):
            return self.dayTextField
        default:
            return super.hitTest(point, with: event)
        }
    }
    
    @objc func handleTextDidChangeNotification(_ notification: Notification) {
        guard let textField = notification.object as? UITextField,
            let text = textField.text
            else {
                return
        }
        
        switch textField {
        case self.yearTextField where text.characters.count == 4:
            self.monthTextField.becomeFirstResponder()
            
        case self.monthTextField where text.characters.count == 2:
            self.dayTextField.becomeFirstResponder()
            
        default:
            break
        }
    }
    
    // Convenience function for setting the value of all three text fields based on a date.
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        self.yearTextField.text = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        self.monthTextField.text = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        self.dayTextField.text = formatter.string(from: date)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension DateFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.rangeOfCharacter(from: self.invalidCharacterSet) == nil
            else {
                return false
        }
        
        guard let currentText = textField.text as NSString?
            else {
                return true
        }
        let resultingText = currentText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.yearTextField:
            if resultingText.characters.count > 4 {
                return false
            }
            
        default:
            if resultingText.characters.count > 2 {
                return false
            }
        }
        
        return true
    }
    
}

extension DateFieldView: DateTextFieldDelegate {
    
    func dateTextFieldDidRequestFocusTransfer(_ textField: DateTextField) {
        switch textField {
        case self.dayTextField:
            self.monthTextField.becomeFirstResponder()
        case self.monthTextField:
            self.yearTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
}

class DateTextField: UITextField {
    
    var dateTextFieldDelegate: DateTextFieldDelegate?
    
    override func deleteBackward() {
        // If the text field was already empty when the backspace was pressed,
        // request for focus to be transferred to the text field on the left.
        if let text = self.text,
            text.isEmpty {
            self.dateTextFieldDelegate?.dateTextFieldDidRequestFocusTransfer(self)
        }
        super.deleteBackward()
    }
    
}

protocol DateTextFieldDelegate {
    func dateTextFieldDidRequestFocusTransfer(_ textField: DateTextField)
}
