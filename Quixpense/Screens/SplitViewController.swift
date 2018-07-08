//
//  SplitViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 08/07/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class SplitViewController: UISplitViewController {
    
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
        
        viewControllers = [
            UINavigationController(rootViewController: ExpensesViewController(persistentContainer: persistentContainer)),
            UINavigationController(nibName: nil, bundle: nil)
        ]
        
        preferredDisplayMode = .allVisible
        
        delegate = self
    }
    
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        guard let secondaryNavigationController = secondaryViewController as? UINavigationController,
            let primaryNavigationController = splitViewController.viewControllers.first as? UINavigationController
            else {
                return
        }
        primaryNavigationController.viewControllers.append(contentsOf: secondaryNavigationController.viewControllers)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let navigationController = secondaryViewController as? UINavigationController,
            navigationController.viewControllers.count > 0 {
            return false
        }
        return true
    }
    
}
