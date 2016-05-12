//
//  ModalNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class ModalNavBarVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = Color.ModalNavigationBarBackgroundColor
        self.navigationBar.tintColor = Color.White
        self.navigationBar.translucent = false
    }
    
}
