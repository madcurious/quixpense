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
        let validateOp = ValidateExpenseOperation(amountText: self.amountText) {[unowned self] result in
            switch result {
            case .error(let error):
                MDAlertDialog.showInPresenter(self, title: error.localizedDescription, message: nil, cancelButtonTitle: "Got it!")
            default:
                break
            }
        }
        
        let categoryInput: CategoryInput = {
            guard let selectedCategory = self.selectedCategory
                else {
                    return .none
            }
            if nil != Global.coreDataStack.newBackgroundContext().object(with: selectedCategory.objectID) as? Category {
                return .id(selectedCategory.objectID)
            }
            let input = CategoryInput.name(selectedCategory.name!)
            return input
        }()
        
        let addOp = AddExpenseOperation(context: nil, amount: NSDecimalNumber(string: self.amountText!), dateSpent: self.customView.dateFieldView.selectedDate, category: categoryInput, tags: nil) {[unowned self] result in
            switch result {
            case .success(_):
                MDAlertDialog.showInPresenter(self, title: "Expense saved.", message: nil, cancelButtonTitle: "Got it!")
            case .error(let error):
                MDAlertDialog.showInPresenter(self, title: error.localizedDescription, message: nil, cancelButtonTitle: "Got it!")
                
            default: break
            }
        }
        
        addOp.addDependency(validateOp)
        
        Global.coreDataStack.viewContext.rollback() // Discard the unsaved category/tag entities.
        
        self.operationQueue.addOperations([validateOp, addOp], waitUntilFinished: false)
    }
    
}
