//
//  MainTabBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class MainTabBarVC: UITabBarController, Themeable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        self.applyTheme()
        
        let tabs = [
            BaseNavBarVC(rootViewController: HomeViewController()),
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func applyTheme() {
        self.tabBar.barTintColor = Global.theme.color(for: .barBackground)
        self.tabBar.tintColor = Global.theme.color(for: .barTint)
    }
    
}
