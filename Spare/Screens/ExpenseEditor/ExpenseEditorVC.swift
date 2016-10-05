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

private let kSpecialKeyPeriod = "."
private let kSpecialKeyBackspace = Icon.ExpenseEditorBackspace.rawValue

/**
 Editor used for adding or editing an expense.
 
 The amount is derived from the property `unformattedAmount`, which is simply the sequence of keys that
 were pressed in the custom keypad.
 */
class ExpenseEditorVC: MDOperationViewController {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    var categories = [Category]()
    
    let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", kSpecialKeyPeriod, "0", kSpecialKeyBackspace]
    let amountFormatter = NumberFormatter()
    var unformattedAmount = ""
    
    let customPickerAnimator = CustomPickerTransitioningDelegate()
    let customPicker = CustomPickerVC()
    
    init(expense: Expense?) {
        self.managedObjectContext = App.coreDataStack.newBackgroundWorkerMOC()
        
        if let objectID = expense?.objectID,
            let expense = self.managedObjectContext.object(with: objectID) as? Expense {
            self.expense = expense
        } else {
            // If adding an expense, by default, the date is the current date and
            // the payment method is cash.
            self.expense = Expense(managedObjectContext: self.managedObjectContext)
            self.expense.dateSpent = Date()
            self.expense.paymentMethod = PaymentMethod.cash.rawValue
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
        
        self.amountFormatter.numberStyle = .currency
        self.amountFormatter.currencySymbol = ""
        self.amountFormatter.usesGroupingSeparator = true
        
        // Because the expense model's amount is dependent on the unformattedAmount property,
        // update the unformattedAmount and the amountFormatter depending on whether the form
        // is being used for editing (expense.amount is non-nil), or for adding a new expense (amount is nil).
        if let amount = self.expense.amount {
            let amountString = amount.stringValue as NSString
            self.unformattedAmount = amountString as String
            
            let rangeOfDecimalPoint = amountString.range(of: ".")
            if rangeOfDecimalPoint.location == NSNotFound {
                self.amountFormatter.alwaysShowsDecimalSeparator = false
                self.amountFormatter.minimumFractionDigits = 0
            } else {
                self.amountFormatter.alwaysShowsDecimalSeparator = true
                self.amountFormatter.minimumFractionDigits = amountString.length - (rangeOfDecimalPoint.location + rangeOfDecimalPoint.length)
            }
        } else {
            self.resetAmountAndFormatter()
        }
        
        self.refreshViewFromModel()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.customView.keypadCollectionView.dataSource = self
        self.customView.keypadCollectionView.delegate = self
        self.customView.keypadCollectionView.register(__EEVCKeypadCell.self, forCellWithReuseIdentifier: ViewID.KeypadCell.rawValue)
        
        self.customView.categoryButton.addTarget(self, action: #selector(handleTapOnCategoryButton), for: .touchUpInside)
        self.customView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
        self.customView.paymentMethodButton.addTarget(self, action: #selector(handleTapOnPaymentMethodButton), for: .touchUpInside)
        
        self.customView.noteTextField.delegate = self
        
        self.customPicker.modalPresentationStyle = .custom
        self.customPicker.transitioningDelegate = self.customPickerAnimator
    }
    
    override func buildOperation() -> MDOperation? {
        let op = MDBlockOperation {
            let fetchRequest = NSFetchRequest(entityName: Category.entityName)
            let categories = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Category]
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
                    self.expense.category = categories.first
                }
                
                self.showView(.primary)
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
        expense.dateSpent = previousDate
        expense.category = previousCategory
        expense.paymentMethod = previousPaymentMethod
        expense.note = nil
        self.expense = expense
        self.resetAmountAndFormatter()
        
        // Update the view.
        self.refreshViewFromModel()
    }
    
    /// Resets the model's amount and the amount formatter's configurations.
    func resetAmountAndFormatter() {
        self.expense.amount = nil
        self.unformattedAmount = ""
        self.amountFormatter.alwaysShowsDecimalSeparator = false
        self.amountFormatter.minimumFractionDigits = 0
    }
    
    func refreshViewFromModel() {
        self.refreshCategoryDisplay()
        self.refreshDateSpentDisplay()
        self.refreshPaymentMethodDisplay()
        self.customView.noteTextField.text = md_nonEmptyString(self.expense.note)
        
        self.refreshAmountDisplay()
    }
    
    func refreshCategoryDisplay() {
        self.customView.categoryButton.setTitle(md_nonEmptyString(self.expense.category?.name), for: .normal)
    }
    
    func refreshDateSpentDisplay() {
        self.customView.dateButton.setTitle(DateFormatter.displayTextForExpenseEditorDate(self.expense.dateSpent), for: .Normal)
    }
    
    func refreshPaymentMethodDisplay() {
        self.customView.paymentMethodButton.setTitle(PaymentMethod(self.expense.paymentMethod?.intValue)?.text, for: .normal)
    }
    
    func refreshAmountDisplay() {
        if self.unformattedAmount.isEmpty {
            self.expense.amount = nil
            self.customView.amountTextField.text = nil
        } else {
            let amountDecimalNumber = NSDecimalNumber(string: self.unformattedAmount)
            self.expense.amount = amountDecimalNumber
            self.customView.amountTextField.text = self.amountFormatter.string(from: amountDecimalNumber)
        }
    }
    
    func appendBackspace() {
        guard self.unformattedAmount.isEmpty == false
            else {
                return
        }
        
        // Remove period in formatter.
        let lastCharacter = self.unformattedAmount.characters.last
        if lastCharacter == Character(kSpecialKeyPeriod) {
            self.amountFormatter.alwaysShowsDecimalSeparator = false
        }
        else if self.unformattedAmount.contains(kSpecialKeyPeriod) {
            // Lessen decimal places.
            self.amountFormatter.minimumFractionDigits -= 1
        }
        
        // Actually remove the last character.
        self.unformattedAmount.remove(at: self.unformattedAmount.characters.index(self.unformattedAmount.endIndex, offsetBy: -1))
        
        self.refreshAmountDisplay()
    }
    
    func appendPeriod() {
        guard self.unformattedAmount.contains(kSpecialKeyPeriod) == false
            else {
                return
        }
        
        self.amountFormatter.alwaysShowsDecimalSeparator = true
        self.unformattedAmount += kSpecialKeyPeriod
        self.refreshAmountDisplay()
    }
    
    func appendNumericKey(_ key: String) {
        if self.unformattedAmount.contains(kSpecialKeyPeriod) == true {
            self.amountFormatter.minimumFractionDigits += 1
        }
        
        self.unformattedAmount += key
        self.refreshAmountDisplay()
    }
    
}

// MARK: - Target actions
extension ExpenseEditorVC {
    
    func handleTapOnCategoryButton() {
        let selectedIndex: Int = {
            guard let currentCategory = self.expense.category,
                let index = self.categories.index(of: currentCategory)
                else {
                    return 0
            }
            return index
        }()
        
        let delegate = CategoryPickerDelegate(categories: self.categories, selectedIndex: selectedIndex)
        delegate.selectionAction = {[unowned self] selectedIndex in
            self.expense.category = self.categories[selectedIndex]
            self.refreshCategoryDisplay()
        }
        
        self.customPicker.delegate = delegate
        self.customPicker.customView.headerLabel.text = "CATEGORY"
        self.present(customPicker, animated: true, completion: nil)
    }
    
    func handleTapOnDateButton() {
        let datePicker = DatePickerVC(selectedDate: self.expense.dateSpent!, delegate: self)
        datePicker.modalPresentationStyle = .custom
        datePicker.transitioningDelegate = self.customPickerAnimator
        self.present(datePicker, animated: true, completion: nil)
    }
    
    func handleTapOnPaymentMethodButton() {
        let selectedIndex: Int = {
            guard let currentPaymentMethod = PaymentMethod(self.expense.paymentMethod?.intValue),
                let index = PaymentMethod.allValues.index(of: currentPaymentMethod)
                else {
                    return 0
            }
            return index
        }()
        
        let delegate = PaymentMethodPickerDelegate(selectedIndex: selectedIndex)
        delegate.selectionAction = {[unowned self] selectedIndex in
            let paymentMethods = PaymentMethod.allValues
            self.expense.paymentMethod = paymentMethods[selectedIndex].rawValue as NSNumber?
            self.refreshPaymentMethodDisplay()
        }
        
        self.customPicker.delegate = delegate
        self.customPicker.customView.headerLabel.text = "PAYMENT METHOD"
        self.present(customPicker, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ExpenseEditorVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.KeypadCell.rawValue, for: indexPath) as! __EEVCKeypadCell
        cell.text = self.keys[(indexPath as NSIndexPath).item]
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpenseEditorVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = self.keys[(indexPath as NSIndexPath).item]
        switch key {
        case kSpecialKeyPeriod:
            self.appendPeriod()
            
        case kSpecialKeyBackspace:
            self.appendBackspace()
            
        default:
            self.appendNumericKey(key)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExpenseEditorVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 3
        let height = collectionView.bounds.size.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - DatePickerVCDelegate
extension ExpenseEditorVC: DatePickerVCDelegate {
    
    func datePickerDidSelectDate(_ date: Date) {
        self.expense.dateSpent = date
        self.refreshDateSpentDisplay()
    }
    
}

// MARK: - UITextFieldDelegate
extension ExpenseEditorVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.customView.noteTextField
            else {
                return false
        }
        
        let newText = ((self.customView.noteTextField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        self.expense.note = newText
        
        return true
    }
    
}
