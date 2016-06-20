//
//  MainContainerVC.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class MainContainerVC: UIViewController {
    
    let customView = __MCVCView.instantiateFromNib() as __MCVCView
    let tabController = UITabBarController(nibName: nil, bundle: nil)
    let tabBar = MainTabBar.instantiateFromNib() as MainTabBar
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        // Create the tabs and make their bottom edges extend to the space occuppied by the hidden tab bar.
        let homeScreen = HomeVC()
        homeScreen.edgesForExtendedLayout = .Bottom
        let settingsScreen = SettingsVC()
        settingsScreen.edgesForExtendedLayout = .Bottom
        
        // Create the tab bar controller, add the tabs, and hide the tab bar.
        self.tabController.viewControllers = [UINavigationController(rootViewController: homeScreen), settingsScreen]
        self.tabController.tabBar.hidden = true
        self.embedChildViewController(self.tabController, toView: self.customView.tabContainer, fillSuperview: true)
        
        self.tabBar.delegate = self
        self.customView.tabBarContainer.addSubviewAndFill(self.tabBar)
        
        self.tabBar.addButton.delegate = self
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
        self.tabController.selectedIndex = index
    }
    
}

extension MainContainerVC: AddButtonDelegate {
    
    func addButtonDidClick() {
        self.presentViewController(ModalNavBarVC(rootViewController: AddExpenseVC()), animated: true, completion: nil)
    }
    
    func addButtonDidCompleteLongPress() {
        self.presentViewController(ModalNavBarVC(rootViewController: AddCategoryVC()), animated: true, completion: nil)
    }
    
}
