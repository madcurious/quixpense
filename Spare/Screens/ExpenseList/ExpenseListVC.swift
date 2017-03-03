//
//  ExpenseListVC.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseListVC: UIViewController {
    
    let customView = _ELVCView.instantiateFromNib()
    let filterButton = MDImageButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage.templateNamed("filterIcon")!)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.tabBarItem.image = UIImage.templateNamed("tabIconExpenseList")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "EXPENSES"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.filterButton)
    }

}
