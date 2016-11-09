//
//  AddExpenseVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class AddExpenseVC: BaseFormVC {
    
    let editor = ExpenseEditorVC(expense: nil)
    let queue = OperationQueue()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "New Expense"
    }
    
    convenience init(preselectedCategory: Category, preselectedDate: Date) {
        self.init()
        
        if let category = self.editor.managedObjectContext.object(with: preselectedCategory.objectID) as? Category {
            self.editor.expense.category = category
        }
        self.editor.expense.dateSpent = preselectedDate as NSDate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.editor)
    }
    
    override func handleTapOnDoneBarButtonItem(_ sender: AnyObject) {
        print("expense: \(self.editor.managedObjectContext.object(with: self.editor.expense.objectID) as! Expense)")
        self.queue.addOperation(
            ValidateExpenseOperation(expense: self.editor.expense)
                .onSuccess({[unowned self] (_) in
                    self.editor.managedObjectContext.saveRecursively({[unowned self] error in
                        if let error = error {
                            MDErrorDialog.showError(error, inPresenter: self)
                            return
                        }
                        
                        MDDispatcher.asyncRunInMainThread {[unowned self] in
                            self.editor.reset()
                        }
                        })
                    })
                .onFail({[unowned self] (error) in
                    MDErrorDialog.showError(error, inPresenter: self)
                    })
        )
    }
    
}

