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
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        self.dismissKeyboard()
    }
    
}
