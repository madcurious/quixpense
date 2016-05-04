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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabs.viewControllers = [HomeVC(), SettingsVC()]
        self.tabs.tabBar.hidden = true
        self.embedChildViewController(self.tabs, toView: self.customView.tabContainer, fillSuperview: true)
        
        self.tabBar.delegate = self
        self.customView.tabBarContainer.addSubviewAndFill(self.tabBar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}

extension MainContainerVC: MainTabBarDelegate {
    
    func mainTabBarDidSelectIndex(index: Int) {
        self.tabs.selectedIndex = index
    }
    
}