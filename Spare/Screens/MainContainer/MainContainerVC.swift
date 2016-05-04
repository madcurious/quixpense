//
//  MainContainerVC.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class MainContainerVC: BaseVC {
    
    let customView = __MCVCView.instantiateFromNib() as __MCVCView
    let tabs = UITabBarController(nibName: nil, bundle: nil)
    let tabBar = MainTabBar.instantiateFromNib() as MainTabBar
    
    override func loadView() {
        self.view = self.customView
        self.customView.tabBarContainer.addSubviewAndFill(self.tabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabs.viewControllers = [HomeVC(), UIViewController(), SettingsVC()]
        self.tabs.tabBar.hidden = true
        self.embedChildViewController(self.tabs, toView: self.customView.tabContainer, fillSuperview: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}