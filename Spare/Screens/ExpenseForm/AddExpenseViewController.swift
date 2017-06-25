//
//  AddExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

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
        
        guard self.amountText.isEmpty == false ||
            self.categoryText.isEmpty == false ||
            self.tagText.isEmpty == false
            else {
                self.customView.reset()
                return
        }
        
        let alertController = UIAlertController(
            title: "Discard changes", message: "Are you sure you want to continue?", preferredStyle: .alert)
        alertController.addCancelAction()
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (_) in
            self.customView.reset()
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
