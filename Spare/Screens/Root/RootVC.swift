//
//  RootVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class RootVC: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = [HomeVC(),
                                AddVC(),
                                SettingsVC()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}