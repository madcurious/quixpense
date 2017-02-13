//
//  RootVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class RootVC: UITabBarController, Themeable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyTheme()
        
        let tabs = [
            BaseNavBarVC(rootViewController: ExpenseListVC()),
            BaseNavBarVC(rootViewController: AddExpenseVC()),
            BaseNavBarVC(rootViewController: SettingsVC())
        ]
        for tab in tabs {
            if let root = tab.viewControllers.first {
                root.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)
            }
        }
        self.viewControllers = tabs
        
    }
    
    func applyTheme() {
        self.tabBar.barTintColor = Global.theme.barBackgroundColor
        self.tabBar.tintColor = Global.theme.barTintColor
    }
    
}
