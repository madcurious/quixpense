//
//  EFPickerSearchVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFPickerSearchVC: UIViewController {
    
    let customView = _EFPSVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
}
