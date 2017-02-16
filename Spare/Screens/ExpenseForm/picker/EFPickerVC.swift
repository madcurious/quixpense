//
//  EFPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFPickerVC: UIViewController {
    
    let customView = _EFPVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.cancelButton.addTarget(self, action: #selector(handleTapOnCancelButton), for: .touchUpInside)
        self.customView.doneButton.addTarget(self, action: #selector(handleTapOnDoneButton), for: .touchUpInside)
    }
    
    func handleTapOnCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
