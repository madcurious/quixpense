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

private enum ViewID: String {
    case KeypadCell = "KeypadCell"
}

class ExpenseEditorVC: MDStatefulViewController {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    var categories = [Category]()
    
    let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", Icon.ExpenseEditorBackspace.rawValue]
    
    init(expense: Expense?) {
        self.managedObjectContext = App.state.coreDataStack.newBackgroundWorkerMOC()
        
        if let objectID = expense?.objectID,
            let expense = self.managedObjectContext.objectWithID(objectID) as? Expense {
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
        
        self.refreshViewFromModel()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.customView.keypadCollectionView.dataSource = self
        self.customView.keypadCollectionView.delegate = self
        self.customView.keypadCollectionView.registerClass(__EEVCKeypadCell.self, forCellWithReuseIdentifier: ViewID.KeypadCell.rawValue)
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
                
                // Upon getting the categories, select the first category by default.
                if self.expense.category == nil {
//                    self.expense.category = categories.first
                    self.expense.category = categories[1]
                }
                
                self.showView(.Primary)
                self.refreshViewFromModel()
        }
        return op
    }
    
    func reset() {
        // Reset the model, but leave the date, category, and payment method the same.
        let previousDate = self.expense.dateSpent
        let previousCategory = self.expense.category
        let previousPaymentMethod = self.expense.paymentMethod
        
        let expense = Expense(managedObjectContext: self.managedObjectContext)
        expense.amount = nil
        expense.dateSpent = previousDate
        expense.category = previousCategory
        expense.paymentMethod = previousPaymentMethod
        expense.note = nil
        self.expense = expense
        
        // Update the view.
        self.refreshViewFromModel()
    }
    
    func refreshViewFromModel() {
        self.customView.categoryButton.setTitle(md_nonEmptyString(self.expense.category?.name), forState: .Normal)
        
        self.customView.dateButton.setTitle(DateFormatter.displayTextForExpenseEditorDate(self.expense.dateSpent), forState: .Normal)
        
        self.customView.paymentMethodButton.setTitle(PaymentMethod(self.expense.paymentMethod?.integerValue)?.text, forState: .Normal)
        
        self.customView.noteTextField.text = md_nonEmptyString(self.expense.note)
        
        self.customView.amountTextField.text = self.expense.amount?.stringValue
    }
    
}

extension ExpenseEditorVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.KeypadCell.rawValue, forIndexPath: indexPath) as! __EEVCKeypadCell
        cell.text = self.keys[indexPath.item]
        return cell
    }
    
}

extension ExpenseEditorVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension ExpenseEditorVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 3
        let height = collectionView.bounds.size.height / 4
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}













/*
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
        
        if let objectID = expense?.objectID,
            let expense = self.managedObjectContext.objectWithID(objectID) as? Expense {
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
        glb_applyGlobalVCSettings(self)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
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
        
        self.customView.noteTextField.delegate = self
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
        expense.amount = nil
        expense.dateSpent = self.datePickerView.date
        expense.category = self.categories[self.categoryPickerView.selectedRowInComponent(0)]
        expense.paymentMethod = PaymentMethod(self.customView.paymentMethodControl.selectedSegmentIndex)?.rawValue
        expense.note = nil
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
        self.customView.amountTextField.text = self.expense.amount?.stringValue
        
        self.customView.categoryTextField.text = md_nonEmptyString(self.expense.category?.name)
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
        
        self.customView.noteTextField.text = md_nonEmptyString(self.expense.note)
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
        case self.customView.noteTextField,
             self.customView.amountTextField:
            let text = NSMutableString(string: textField.text ?? "")
            text.replaceCharactersInRange(range, withString: string)
            
            if textField == self.customView.noteTextField {
                self.expense.note = text as String
            }
            
            else {
                // If the entered amount has invalid characters, return false.
                if string.hasCharactersFromSet(NSCharacterSet.decimalNumberCharacterSet().invertedSet) {
                    return false
                }
                
                if let amountText = md_nonEmptyString(text) {
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
*/