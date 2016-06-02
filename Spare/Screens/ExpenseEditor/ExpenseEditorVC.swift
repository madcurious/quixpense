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
    let datePickerView = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    var categories = [Category]()
    
    init(expense: Expense?) {
        self.managedObjectContext = App.state.coreDataStack.newBackgroundWorkerMOC()
        if let expense = expense {
            self.expense = expense
        } else {
            // If adding an expense, by default, the date is the current date and
            // the payment method is cash.
            self.expense = Expense(managedObjectContext: self.managedObjectContext)
            self.expense.dateSpent = NSDate()
            self.expense.paymentMethod = PaymentMethod.Cash.rawValue
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
        
        self.customView.itemDescriptionTextField.delegate = self
        self.customView.amountTextField.delegate = self
        
        // Setup the picker views for the category and date fields
        self.customView.categoryTextField.inputView = self.categoryPickerView
        self.customView.categoryTextField.delegate = self
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.delegate = self
        self.customView.dateTextField.inputView = self.datePickerView
        self.customView.dateTextField.delegate = self
        self.datePickerView.datePickerMode = .Date
        self.datePickerView.addTarget(self, action: #selector(handleChangeOnDatePicker), forControlEvents: .ValueChanged)
        
        self.customView.paymentMethodControl.addTarget(self, action: #selector(handleChangeOnPaymentMethod), forControlEvents: .ValueChanged)
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
            
            // Upon getting the categories, select the first category by default.
            if self.expense.category == nil {
                self.expense.category = categories.first
            }
            
            self.showView(.Primary)
            self.refreshViewFromModel()
        }
        return op
    }
    
    func reset() {
        // Reset the model, but leave the date, category, and payment method the same.
        let expense = Expense(managedObjectContext: self.managedObjectContext)
        expense.itemDescription = nil
        expense.amount = nil
        expense.dateSpent = self.datePickerView.date
        expense.category = self.categories[self.categoryPickerView.selectedRowInComponent(0)]
        expense.paymentMethod = PaymentMethod(self.customView.paymentMethodControl.selectedSegmentIndex)?.rawValue
        self.expense = expense
        
        // Update the view.
        self.refreshViewFromModel()
    }
    
    func stringForDate(date: NSDate) -> String {
        if date.isSameDayAsDate(NSDate()) {
            self.dateFormatter.dateStyle = .LongStyle
            return "Today, \(self.dateFormatter.stringFromDate(date))"
        }
        
        self.dateFormatter.dateStyle = .FullStyle
        return self.dateFormatter.stringFromDate(date)
    }
    
    func updateDateFromDatePicker() {
        // Update the model.
        self.expense.dateSpent = self.datePickerView.date
        
        // Update the view.
        self.customView.dateTextField.text = self.stringForDate(self.datePickerView.date)
    }
    
    func updatePaymentMethodFromSegmentedControl() {
        self.expense.paymentMethod = PaymentMethod(self.customView.paymentMethodControl.selectedSegmentIndex)?.rawValue
    }
    
    func refreshViewFromModel() {
        self.customView.itemDescriptionTextField.text = nonEmptyString(self.expense.itemDescription)
        self.customView.amountTextField.text = nonEmptyString(self.expense.amount)
        
        self.customView.categoryTextField.text = nonEmptyString(self.expense.category?.name)
        if let category = self.expense.category,
            let categoryIndex = self.categories.indexOf(category) {
            self.categoryPickerView.selectRow(categoryIndex, inComponent: 0, animated: false)
        }
        
        if let dateSpent = self.expense.dateSpent {
            self.customView.dateTextField.text = self.stringForDate(dateSpent)
            self.datePickerView.date = dateSpent
        } else {
            self.customView.dateTextField.text = nil
        }
        
        self.customView.paymentMethodControl.selectedSegmentIndex = {[unowned self] in
            if let paymentMethod = PaymentMethod(self.expense.paymentMethod?.integerValue) {
                return paymentMethod.rawValue
            }
            return 0
        }()
    }
    
    // MARK: Target actions
    
    func handleChangeOnDatePicker() {
        self.updateDateFromDatePicker()
    }
    
    func handleChangeOnPaymentMethod() {
        self.dismissKeyboard()
        self.updatePaymentMethodFromSegmentedControl()
    }
    
}

// MARK: - UIPickerViewDataSource
extension ExpenseEditorVC: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
}

// MARK: - UIPickerViewDelegate
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

// MARK: - UITextFieldDelegate
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
            
        case self.customView.dateTextField:
            self.updateDateFromDatePicker()
            
        default:
            break
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            
            // Description and amount fields.
        case self.customView.itemDescriptionTextField,
             self.customView.amountTextField:
            let text = NSMutableString(string: textField.text ?? "")
            text.replaceCharactersInRange(range, withString: string)
            
            if textField == self.customView.itemDescriptionTextField {
                self.expense.itemDescription = text as String
            }
            
            else {
                // If the entered amount has invalid characters, return false.
                if string.hasCharactersFromSet(NSCharacterSet.decimalNumberCharacterSet().invertedSet) {
                    return false
                }
                
                if let amountText = nonEmptyString(text) {
                    self.expense.amount = NSDecimalNumber(string: amountText)
                } else {
                    self.expense.amount = nil
                }
            }
            
            return true
            
            // Category and date picker text fields.
        default:
            return false
        }
    }
    
}
