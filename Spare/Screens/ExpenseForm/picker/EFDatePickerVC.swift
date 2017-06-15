//
//  EFDatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 17/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFDatePickerVC: EFPickerVC {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    override func loadView() {
        super.loadView()
        
        self.customView.pickerViewContainerHeight = self.datePicker.intrinsicContentSize.height
        self.customView.pickerViewContainer.addSubviewAndFill(self.datePicker)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DATE"
    }
    
}
