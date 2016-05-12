//
//  AddExpenseVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class AddExpenseVC: BaseFormVC {
    
    let editor = ExpenseEditorVC(expense: nil)
    let queue = NSOperationQueue()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "NEW EXPENSE"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.editor)
    }
    
    override func handleTapOnDoneBarButtonItem(sender: AnyObject) {
        self.queue.addOperation(
            ValidateExpenseOperation(expense: self.editor.expense)
        )
    }
    
}

