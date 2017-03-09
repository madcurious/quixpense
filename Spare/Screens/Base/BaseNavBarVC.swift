//
//  BaseNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class BaseNavBarVC: UINavigationController, Themeable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.applyTheme()
    }
    
    func applyTheme() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Global.theme.color(for: .barBackground)
        self.navigationBar.tintColor = Global.theme.color(for: .barTint)
        self.navigationBar.titleTextAttributes = [
            NSFontAttributeName : Font.bold(17),
            NSForegroundColorAttributeName : Global.theme.color(for: .barTint)
        ]
    }
    
}

extension BaseNavBarVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.edgesForExtendedLayout = []
    }
    
}
