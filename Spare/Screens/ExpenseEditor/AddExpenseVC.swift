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
    let queue = NSOperationQueue()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "New Expense"
    }
    
    convenience init(preselectedCategory: Category, preselectedDate: NSDate) {
        self.init()
        
        if let category = self.editor.managedObjectContext.objectWithID(preselectedCategory.objectID) as? Category {
            self.editor.expense.category = category
        }
        self.editor.expense.dateSpent = preselectedDate
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
                .onSuccess({[unowned self] (_) in
                    self.editor.managedObjectContext.saveContext {[unowned self] (result) in
                        switch result {
                        case .Failure(let error as NSError):
                            MDErrorDialog.showError(error, inPresenter: self)
                        default:
                            MDDispatcher.asyncRunInMainThread({
                                // Throw a notification to notify summary views.
                                let system = NSNotificationCenter.defaultCenter()
                                system.postNotificationName(NSNotificationName.PerformedExpenseOperation.string(), object: self.editor.expense)
                                
                                self.editor.reset()
                            })
                        }
                    }
                    })
                .onFail({[unowned self] (error) in
                    MDErrorDialog.showError(error, inPresenter: self)
                    })
        )
    }
    
}

