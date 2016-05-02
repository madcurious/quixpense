//
//  RootVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class RootVC: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = [
            HomeVC(),
            {
                let placeholder = UIViewController()
                placeholder.tabBarItem = UITabBarItem(title: "Add", image: nil, selectedImage: nil)
                return placeholder
            }(),
            SettingsVC()]
        self.tabBar.translucent = false
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}

extension RootVC: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        guard let index = self.viewControllers?.indexOf(viewController)
            where index == 1
            else {
                return true
        }
        
        let modal = BaseNavController(rootViewController: AddModalVC())
        self.presentViewController(modal, animated: true, completion: nil)
        return false
    }
    
}