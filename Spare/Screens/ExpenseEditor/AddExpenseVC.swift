//
//  AddExpenseVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class AddExpenseVC: BaseFormVC {
    
    let editor = ExpenseEditorVC()
    
    override init() {
        super.init()
        self.title = "NEW EXPENSE"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.editor)
    }
    
}

