//
//  BaseNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class BaseNavBarVC: UINavigationController, Themeable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
    }
    
    func applyTheme() {
        self.navigationBar.barTintColor = Global.theme.barBackgroundColor
        self.navigationBar.tintColor = Global.theme.barTintColor
        self.navigationBar.titleTextAttributes = [
            NSFontAttributeName : Font.bold(17),
            NSForegroundColorAttributeName : Global.theme.barTintColor
        ]
    }
    
}
