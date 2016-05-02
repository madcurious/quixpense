//
//  AddModalVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class AddModalVC: BaseVC {
    
    let addExpenseVC = UIViewController()
    let addCategoryVC = EditCategoryVC(category: nil)
    let customView = __AMVCView.instantiateFromNib() as __AMVCView
    
    var hasAppeared = false
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.addExpenseVC, toView: self.customView.contentView, fillSuperview: false)
        self.embedChildViewController(self.addCategoryVC, toView: self.customView.contentView, fillSuperview: false)
        self.customView.setupLayoutRulesForPages(self.addExpenseVC.view, secondPage: self.addCategoryVC.view)
        
        self.addCancelAndDoneBarButtonItems("CLOSE", doneButtonTitle: "SAVE")
    }
    
}

