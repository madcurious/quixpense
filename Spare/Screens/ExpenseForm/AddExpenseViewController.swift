//
//  AddExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class AddExpenseViewController: ExpenseFormViewController {
    
    let operationQueue = OperationQueue()
    
    override init() {
        super.init()
        self.title = "ADD EXPENSE"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func handleTapOnCancelButton() {
        self.view.endEditing(true)
        
        guard self.hasUnsavedChanges()
            else {
                self.resetFields()
                return
        }
        
        let alertController = UIAlertController(
            title: "Discard changes", message: "Are you sure you want to continue?", preferredStyle: .alert)
        alertController.addCancelAction()
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (_) in
            self.resetFields()
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func handleTapOnDoneButton() {
        let validateOp = ValidateExpenseOperation(amountText: self.inputModel.amountText) {[unowned self] result in
            switch result {
            case .error(let error):
                MDAlertDialog.showInPresenter(self, title: error.localizedDescription, message: nil, cancelButtonTitle: "Got it!")
            default:
                break
            }
        }
        
        let addOp = AddExpenseOperation(context: nil, inputModel: self.inputModel) {[unowned self] result in
            switch result {
            case .success(_):
                MDDispatcher.asyncRunInMainThread {
                    MDAlertDialog.showInPresenter(self, title: "Expense saved.", message: nil, cancelButtonTitle: "Got it!")
                    self.resetFields()
                }
                
            case .error(let error):
                MDAlertDialog.showInPresenter(self, title: error.localizedDescription, message: nil, cancelButtonTitle: "Got it!")
                
            default: break
            }
        }
        
        addOp.addDependency(validateOp)
        
//        Global.coreDataStack.viewContext.rollback() // Discard the unsaved category/tag entities.
        
        self.operationQueue.addOperations([validateOp, addOp], waitUntilFinished: false)
    }
    
}
