//
//  RootTabBarController.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock
import CoreData

class RootTabBarController: UITabBarController {
    
    var hasAppeared = false
    let queue = OperationQueue()
    weak var container: NSPersistentContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            SetupViewController() { container in
                DispatchQueue.main.async {
                    self.container = container
                    self.setupTabs(with: container)
                }
            }
        ]
    }
    
    func setupTabs(with container: NSPersistentContainer) {
        let placeholderViewController = UIViewController(nibName: nil, bundle: nil)
        placeholderViewController.title = "Add"
        placeholderViewController.tabBarItem.image = UIImage.template(named: "tabIconAdd")
        viewControllers = [
            UINavigationController(rootViewController: ExpensesViewController(container: container)),
            placeholderViewController,
            UINavigationController(rootViewController: SettingsViewController())
        ]
        delegate = self
    }
    
}

extension RootTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Add",
            let container = container {
            present(FormNavigationController(rootViewController: ExpenseEditorViewController(container: container)), animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
