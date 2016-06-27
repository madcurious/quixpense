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
    
    override var formScrollView: UIScrollView {
        return self.editor.customView.scrollView
    }
    
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
                .onSuccess({[unowned self] (_) in
                    self.editor.managedObjectContext.saveContext {[unowned self] (result) in
                        switch result {
                        case .Failure(let error as NSError):
                            MDErrorDialog.showError(error, inPresenter: self)
                        default:
                            MDDispatcher.asyncRunInMainThread({
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

