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
            UINavigationController(rootViewController: HomeVC()),
            BaseNavBarVC(rootViewController: SettingsVC())
        ]
        self.tabController.tabBar.hidden = true
        self.embedChildViewController(self.tabController, toView: self.customView.tabContainer, fillSuperview: true)
        
        self.tabBar.delegate = self
        self.customView.tabBarContainer.addSubviewAndFill(self.tabBar)
        
        self.tabBar.addButton.delegate = self
                
        // Listen for taps on category cells in summary cards.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(handleTapOnSummaryCell(_:)), name: Event.CategoryTappedInSummaryVC.rawValue, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func handleTapOnSummaryCell(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let category = userInfo["category"] as? Category,
            let startDate = userInfo["startDate"] as? NSDate,
            let endDate = userInfo["endDate"] as? NSDate
            else {
                return
        }
        
        let expenseListVC = ExpenseListVC(category: category, startDate: startDate, endDate: endDate)
        self.navigationController?.pushViewController(expenseListVC, animated: true)
    }
    
}

extension MainContainerVC: MainTabBarDelegate {
    
    func mainTabBarDidSelectIndex(index: Int) {
        self.tabController.selectedIndex = index
    }
    
}

extension MainContainerVC: AddButtonDelegate {
    
    func addButtonDidClick() {
        self.presentViewController(BaseNavBarVC(rootViewController: AddExpenseVC()), animated: true, completion: nil)
    }
    
    func addButtonDidCompleteLongPress() {
        self.presentViewController(BaseNavBarVC(rootViewController: AddCategoryVC()), animated: true, completion: nil)
    }
    
}
