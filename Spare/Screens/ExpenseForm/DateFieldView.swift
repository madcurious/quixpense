//
//  DateFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 17/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class DateFieldView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        return formatter
    }()
    
    private lazy var datePicker = UIDatePicker(frame: .zero)
    var date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearAllBackgroundColors()
        
        self.setToCurrentDate()
        
        self.datePicker.addObserver(self, forKeyPath: #keyPath(UIDatePicker.date), options: [.new], context: nil)
        
        self.textField.inputView = self.datePicker
    }
    
    func setToCurrentDate() {
        self.setDate(Date())
    }
    
    func setDate(_ date: Date) {
        self.date = date
        self.textField.text = self.dateFormatter.string(from: date)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(UIDatePicker.date)
            else {
                return
        }
        self.setDate(self.datePicker.date)
    }
    
}

extension DateFieldView: Themeable {
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.textColor = Global.theme.color(for: .regularText)
    }
    
}
