//
//  DatePickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func datePicker(_ datePicker: DatePickerViewController, didSelectDate date: Date)
}

class DatePickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedDate: Date) {
        let picker = DatePickerViewController()
        picker.delegate = presenter
        picker.datePicker.date = selectedDate
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    let datePicker = UIDatePicker()
    var delegate: DatePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.contentViewHeight.constant = datePicker.intrinsicContentSize.height
        customView.contentView.backgroundColor = .white
        customView.contentView.addSubviewsAndFill(datePicker)
        
        if delegate != nil {
            datePicker.addTarget(self, action: #selector(handleValueChangeOnDatePicker), for: .valueChanged)
        }
    }
    
}

@objc extension DatePickerViewController {
    
    override func handleTapOnDimView() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleValueChangeOnDatePicker() {
        if let delegate = delegate {
            delegate.datePicker(self, didSelectDate: datePicker.date)
        }
    }
    
}
