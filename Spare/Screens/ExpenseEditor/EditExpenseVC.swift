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
    let queue = NSOperationQueue()
    
    override var formScrollView: UIScrollView {
        return self.editor.customView.scrollView
    }
    
    init(expense: Expense) {
        self.editor = ExpenseEditorVC(expense: expense)
        super.init(nibName: nil, bundle: nil)
        self.title = "EDIT EXPENSE"
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
                            MDDispatcher.asyncRunInMainThread({[unowned self] in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
                    }
                    })
                .onFail({[unowned self] (error) in
                    MDErrorDialog.showError(error, inPresenter: self)
                    })

        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
