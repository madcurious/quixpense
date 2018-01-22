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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            SetupViewController() { container in
                DispatchQueue.main.async {
                    self.setupTabs(with: container)
                }
            }
        ]
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if hasAppeared == false {
//            queue.addOperation {
//                let loadOp = BRLoadPersistentContainer(documentName: "Model", inMemory: false, completionBlock: nil)
//                self.queue.addOperations([loadOp], waitUntilFinished: true)
//                switch loadOp.result! {
//                case .error(let error):
//                    DispatchQueue.main.async {
//                        BRAlertDialog.showInPresenter(self, title: "Error", message: error.localizedDescription, cancelButtonTitle: "OK")
//                    }
//                case .success(let container):
//                    let generateOp = GenerateDummy(context: container.newBackgroundContext(), completionBlock: nil)
//                    self.queue.addOperations([generateOp], waitUntilFinished: true)
//                    DispatchQueue.main.async {
//                        self.setupTabs(with: container)
//                    }
//                }
//            }
//            hasAppeared = true
//        }
//    }
    
    func setupTabs(with container: NSPersistentContainer) {
        let placeholderViewController = UIViewController(nibName: nil, bundle: nil)
        placeholderViewController.title = "Add"
        placeholderViewController.tabBarItem.image = UIImage.template(named: "tabIconAdd")
        viewControllers = [
            UINavigationController(rootViewController: ExpensesViewController(container: container)),
            placeholderViewController,
            UINavigationController(rootViewController: SettingsViewController())
        ]
    }
    
}
