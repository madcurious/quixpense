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
        let validateOperation = ValidateExpenseOperation(amountText: self.amountText)
        validateOperation.successBlock = {[unowned self] _ in
            print("SUCCESS")
        }
        validateOperation.failureBlock = {[unowned self] error in
            if let validationError = error as? ValidateExpenseOperation.Error {
                MDErrorDialog.showError(validationError, from: self, dialogTitle: validationError.localizedDescription, cancelButtonTitle: "Got it!")
            }
        }
        validateOperation.start()
    }
    
}
