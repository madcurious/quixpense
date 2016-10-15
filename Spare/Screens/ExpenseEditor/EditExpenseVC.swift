//
//  EditExpenseVC.swift
//  Spare
//
//  Created by Matt Quiros on 01/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class EditExpenseVC: BaseFormVC {
    
    let editor: ExpenseEditorVC
    let queue = OperationQueue()
    
    init(expense: Expense) {
        self.editor = ExpenseEditorVC(expense: expense)
        super.init(nibName: nil, bundle: nil)
        self.title = "Edit Expense"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.editor)
    }
    
    override func handleTapOnDoneBarButtonItem(_ sender: AnyObject) {
        self.queue.addOperation(
            ValidateExpenseOperation(expense: self.editor.expense)
                .onSuccess({[unowned self] (_) in
                    self.editor.managedObjectContext.saveRecursively({[unowned self] (error) in
                        if let error = error {
                            MDErrorDialog.showError(error, inPresenter: self)
                            return
                        }
                        
                        MDDispatcher.asyncRunInMainThread {[unowned self] in
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                    })
                .onFail({[unowned self] error in
                    MDErrorDialog.showError(error, inPresenter: self)
                    })

        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
