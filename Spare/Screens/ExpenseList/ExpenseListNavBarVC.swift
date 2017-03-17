//
//  ExpenseListNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListNavBarVC: BaseNavBarVC {
    
    let editingNavigationBar = UINavigationBar(frame: CGRect.zero)
    let expenseListVC = ExpenseListVC(nibName: nil, bundle: nil)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setViewControllers([self.expenseListVC], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editingNavigationBar.isTranslucent = false
        self.editingNavigationBar.barTintColor = Global.theme.color(for: .expenseListSectionHeaderBackground)
        self.editingNavigationBar.tintColor = Global.theme.color(for: .barTint)
        self.editingNavigationBar.alpha = 0
        self.editingNavigationBar.setItems([self.expenseListVC.editingNavigationItem], animated: false)
        
        self.setViewControllers([self.expenseListVC], animated: false)
        
        self.view.addSubview(self.editingNavigationBar)
        self.view.backgroundColor = Global.theme.color(for: .mainBackground)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // The editingNavigationBar's y and height depend on the size of the status bar.
        let editingNavigationBarY = UIApplication.shared.statusBarFrame.size.height > 20 ? self.navigationBar.frame.origin.y : 0
        let heightOffset = UIApplication.shared.statusBarFrame.size.height > 20 ? 0 : UIApplication.shared.statusBarFrame.size.height
        
        self.editingNavigationBar.frame = CGRect(x: 0,
                                                 y: editingNavigationBarY,
                                                 width: self.navigationBar.frame.size.width,
                                                 height: self.navigationBar.frame.size.height + heightOffset)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.navigationBar.alpha = editing ? 0 : 1
        self.editingNavigationBar.alpha = editing ? 1 : 0
    }
    
}
