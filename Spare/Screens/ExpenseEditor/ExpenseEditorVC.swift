//
//  ExpenseEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 03/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import Mold

class ExpenseEditorVC: MDStatefulViewController {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    let categoryPickerView = UIPickerView()
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    var categories = [Category]()
    
    init(expense: Expense?) {
        self.managedObjectContext = App.state.coreDataStack.newBackgroundWorkerMOC()
        if let expense = expense {
            self.expense = expense
        } else {
            self.expense = Expense(managedObjectContext: self.managedObjectContext)
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGlobalVCSettings(self)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.customView.categoryTextField.inputView = self.categoryPickerView
        self.customView.categoryTextField.delegate = self
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.delegate = self
    }
    
    func reset() {
        let expense = Expense(managedObjectContext: self.managedObjectContext)
        expense.itemDescription = nil
        expense.amount = nil
        expense.dateSpent = NSDate()
        expense.category = nil
        expense.paymentMethod = PaymentMethod(self.customView.paymentMethodControl.selectedSegmentIndex).rawValue
        self.expense = expense
    }
    
    override func buildOperation() -> MDOperation? {
        let op = MDBlockOperation {
            let fetchRequest = NSFetchRequest(entityName: Category.entityName)
            guard let categories = try self.managedObjectContext.executeFetchRequest(fetchRequest) as? [Category]
                else {
                    throw Error.AppUnknownError
            }
            return categories
        }
        .onSuccess {[unowned self] (result) in
            guard let categories = result as? [Category]
                else {
                    return
            }
            
            self.categories = categories
            self.categoryPickerView.reloadAllComponents()
            self.showView(.Primary)
        }
        return op
    }
    
}

extension ExpenseEditorVC: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
}

extension ExpenseEditorVC: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = self.categories[row]
        self.customView.categoryTextField.text = selectedCategory.name
        self.expense.category = selectedCategory
    }
    
}

extension ExpenseEditorVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Keep the text left-aligned.
        guard let pickerTextField = textField as? __EEVCPickerTextField
            else {
                return
        }
        pickerTextField.moveCursorToLeft()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        switch textField {
            
        case self.customView.categoryTextField:
            if let firstCategory = self.categories.first
                where self.expense.category == nil {
                self.customView.categoryTextField.text = firstCategory.name
            }
            
        default:
            ()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.customView.categoryTextField:
            return false
            
        default:
            return true
        }
    }
    
}
