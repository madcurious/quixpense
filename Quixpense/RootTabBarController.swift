//
//  RootTabBarController.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderViewController = UIViewController(nibName: nil, bundle: nil)
        placeholderViewController.title = "Add"
        placeholderViewController.tabBarItem.image = UIImage.template(named: "tabIconAdd")
        viewControllers = [
            UINavigationController(rootViewController: ExpensesViewController()),
            placeholderViewController,
            UINavigationController(rootViewController: SettingsViewController())
        ]
    }
    
}
