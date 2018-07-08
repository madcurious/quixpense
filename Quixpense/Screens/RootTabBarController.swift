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
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
//        viewControllers = [
//            SetupViewController() { container in
//                DispatchQueue.main.async {
//                    self.container = container
//                    self.setupTabs(with: container)
//                }
//            }
//        ]
    }
    
    func setupTabs() {
        let placeholderViewController = UIViewController(nibName: nil, bundle: nil)
        placeholderViewController.title = "Add"
        placeholderViewController.tabBarItem.image = UIImage.template(named: "tabIconAdd")
        viewControllers = [
            UINavigationController(rootViewController: ExpensesViewController(persistentContainer: persistentContainer)),
            placeholderViewController,
            UINavigationController(rootViewController: SettingsViewController())
        ]
        delegate = self
    }
    
}

extension RootTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Add" {
            present(UINavigationController(rootViewController: ExpenseEditorViewController(container: persistentContainer)), animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
