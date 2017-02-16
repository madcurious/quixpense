//
//  ExpenseFormVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseFormVC: UIViewController {
    
    let customView = _EFVCView.instantiateFromNib()
    let pickerTransitioningDelegate = EFPickerVCTransitioningDelegate()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapRecognizer)
        
        self.customView.dateBox.fieldButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    func handleTapOnDateButton() {
        let picker = EFDatePickerVC(nibName: nil, bundle: nil)
        picker.setCustomTransitioningDelegate(self.pickerTransitioningDelegate)
        self.present(picker, animated: true, completion: nil)
    }
    
}
