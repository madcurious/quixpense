//
//  _EFEVCDPVCDatePickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 30/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol _EFEVCDPVCDatePickerCellDelegate {
    
    func datePickerCellDidChangeDate(_ date: Date, for bound: DateRange.Bound)
    
}

class _EFEVCDPVCDatePickerCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var bound = DateRange.Bound.from
    var delegate: _EFEVCDPVCDatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.datePicker.addTarget(self, action: #selector(handleValueChangeOnDatePicker), for: .valueChanged)
        
        self.selectionStyle = .none
    }
    
    var date: Date {
        get {
            return self.datePicker.date
        }
        set {
            self.datePicker.date = newValue
        }
    }
    
    func handleValueChangeOnDatePicker() {
        if let delegate = self.delegate {
            delegate.datePickerCellDidChangeDate(self.datePicker.date, for: self.bound)
        }
    }
    
}
