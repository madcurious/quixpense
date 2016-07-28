//
//  BaseNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class BaseNavBarVC: UINavigationController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.barTintColor = Color.UniversalBackgroundColor
        self.navigationBar.tintColor = Color.UniversalTextColor
        self.navigationBar.translucent = false
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}
