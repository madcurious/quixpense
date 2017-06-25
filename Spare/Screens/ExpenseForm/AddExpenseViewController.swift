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
        
        guard self.amountText.isEmpty &&
            self.categoryText.isEmpty &&
            self.tagText.isEmpty
            else {
                self.customView.reset()
                return
        }
        
        let alertController = UIAlertController(title: "Discard changes", message: "Are you sure you want to continue?", preferredStyle: .alert)
    }
    
}
