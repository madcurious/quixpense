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
        
        // Create the tab bar controller, add the tabs, and hide the tab bar.
        self.tabController.viewControllers = [
            BaseNavBarVC(rootViewController: HomeVC()),
            BaseNavBarVC(rootViewController: SettingsVC())
        ]
        self.tabController.tabBar.isHidden = true
        self.embedChildViewController(self.tabController, toView: self.customView.tabContainer, fillSuperview: true)
        
        self.tabBar.delegate = self
        self.customView.tabBarContainer.addSubviewAndFill(self.tabBar)
        
        self.tabBar.addButton.delegate = self
                
        // Listen for taps on category cells in summary cards.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleTapOnSummaryCell(_:)), name: NSNotification.Name(rawValue: Event.CategoryTappedInSummaryVC.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func handleTapOnSummaryCell(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
            let category = userInfo["category"] as? Category,
            let startDate = userInfo["startDate"] as? Date,
            let endDate = userInfo["endDate"] as? Date
            else {
                return
        }
        
        let expenseListVC = ExpenseListVC(category: category, startDate: startDate, endDate: endDate)
        self.navigationController?.pushViewController(expenseListVC, animated: true)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
}

extension MainContainerVC: MainTabBarDelegate {
    
    func mainTabBarDidSelectIndex(_ index: Int) {
        self.tabController.selectedIndex = index
    }
    
}

extension MainContainerVC: AddButtonDelegate {
    
    func addButtonDidClick() {
        guard App.allCategories() != nil
            else {
                return
        }
        self.present(BaseNavBarVC(rootViewController: AddExpenseVC()), animated: true, completion: nil)
    }
    
    func addButtonDidCompleteLongPress() {
        self.present(BaseNavBarVC(rootViewController: AddCategoryVC()), animated: true, completion: nil)
    }
    
}
