//
//  BaseFormVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class BaseFormVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.applyCommonFormBehaviors()
        
        self.addCancelAndDoneBarButtonItems("CANCEL", doneButtonTitle: "SAVE")
        
        let barButtonAttributes = [
            NSFontAttributeName: Font.BarButtonItems,
            NSForegroundColorAttributeName: Color.ModalNavigationBarTintColor
        ]
        if let leftBarButtonItem = self.navigationItem.leftBarButtonItem {
            leftBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
            rightBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = Color.ModalNavigationBarTintColor
        titleLabel.font = Font.NavigationBarTitle
        titleLabel.text = self.title
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
}