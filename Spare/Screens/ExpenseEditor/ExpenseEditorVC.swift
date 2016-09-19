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

class ExpenseEditorVC: MDOperationViewController {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    var categories = [Category]()
    
    let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", kSpecialKeyPeriod, "0", kSpecialKeyBackspace]
    let amountFormatter = NSNumberFormatter()
    var unformattedAmount = ""
    
    let customPickerAnimator = CustomPickerTransitioningDelegate()
    let customPicker = CustomPickerVC()
    
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
        
        self.amountFormatter.numberStyle = .CurrencyStyle
        self.amountFormatter.currencySymbol = ""
        self.amountFormatter.usesGroupingSeparator = true
        self.resetAmount()
        self.refreshViewFromModel()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.customView.keypadCollectionView.dataSource = self
        self.customView.keypadCollectionView.delegate = self
        self.customView.keypadCollectionView.registerClass(__EEVCKeypadCell.self, forCellWithReuseIdentifier: ViewID.KeypadCell.rawValue)
        
        self.customView.categoryButton.addTarget(self, action: #selector(handleTapOnCategoryButton), forControlEvents: .TouchUpInside)
        self.customView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), forControlEvents: .TouchUpInside)
        self.customView.paymentMethodButton.addTarget(self, action: #selector(handleTapOnPaymentMethodButton), forControlEvents: .TouchUpInside)
        
        self.customPicker.modalPresentationStyle = .Custom
        self.customPicker.transitioningDelegate = self.customPickerAnimator
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
                    self.expense.category = categories.first
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
        expense.dateSpent = previousDate
        expense.category = previousCategory
        expense.paymentMethod = previousPaymentMethod
        expense.note = nil
        self.expense = expense
        self.resetAmount()
        
        // Update the view.
        self.refreshViewFromModel()
    }
    
    /// Resets the model's amount and all other properties related to formatting.
    func resetAmount() {
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
        self.customView.categoryButton.setTitle(md_nonEmptyString(self.expense.category?.name), forState: .Normal)
    }
    
    func refreshDateSpentDisplay() {
        self.customView.dateButton.setTitle(DateFormatter.displayTextForExpenseEditorDate(self.expense.dateSpent), forState: .Normal)
    }
    
    func refreshPaymentMethodDisplay() {
        self.customView.paymentMethodButton.setTitle(PaymentMethod(self.expense.paymentMethod?.integerValue)?.text, forState: .Normal)
    }
    
    func refreshAmountDisplay() {
        if self.unformattedAmount.isEmpty {
            self.expense.amount = nil
            self.customView.amountTextField.text = nil
        } else {
            let amountDecimalNumber = NSDecimalNumber(string: self.unformattedAmount)
            self.expense.amount = amountDecimalNumber
            self.customView.amountTextField.text = self.amountFormatter.stringFromNumber(amountDecimalNumber)
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
        else if self.unformattedAmount.containsString(kSpecialKeyPeriod) {
            // Lessen decimal places.
            self.amountFormatter.minimumFractionDigits -= 1
        }
        
        // Actually remove the last character.
        self.unformattedAmount.removeAtIndex(self.unformattedAmount.endIndex.advancedBy(-1))
        
        self.refreshAmountDisplay()
    }
    
    func appendPeriod() {
        guard self.unformattedAmount.containsString(kSpecialKeyPeriod) == false
            else {
                return
        }
        
        self.amountFormatter.alwaysShowsDecimalSeparator = true
        self.unformattedAmount += kSpecialKeyPeriod
        self.refreshAmountDisplay()
    }
    
    func appendNumericKey(key: String) {
        if self.unformattedAmount.containsString(kSpecialKeyPeriod) == true {
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
                let index = self.categories.indexOf(currentCategory)
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
        self.presentViewController(customPicker, animated: true, completion: nil)
    }
    
    func handleTapOnDateButton() {
        let datePicker = DatePickerVC(selectedDate: self.expense.dateSpent!, delegate: self)
        datePicker.modalPresentationStyle = .Custom
        datePicker.transitioningDelegate = self.customPickerAnimator
        self.presentViewController(datePicker, animated: true, completion: nil)
    }
    
    func handleTapOnPaymentMethodButton() {
        let selectedIndex: Int = {
            guard let currentPaymentMethod = PaymentMethod(self.expense.paymentMethod?.integerValue),
                let index = PaymentMethod.allValues.indexOf(currentPaymentMethod)
                else {
                    return 0
            }
            return index
        }()
        
        let delegate = PaymentMethodPickerDelegate(selectedIndex: selectedIndex)
        delegate.selectionAction = {[unowned self] selectedIndex in
            let paymentMethods = PaymentMethod.allValues
            self.expense.paymentMethod = paymentMethods[selectedIndex].rawValue
            self.refreshPaymentMethodDisplay()
        }
        
        self.customPicker.delegate = delegate
        self.customPicker.customView.headerLabel.text = "PAYMENT METHOD"
        self.presentViewController(customPicker, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
extension ExpenseEditorVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let key = self.keys[indexPath.item]
        switch key {
        case kSpecialKeyPeriod:
            self.appendPeriod()
            
        case kSpecialKeyBackspace:
            self.appendBackspace()
            
        default:
            self.appendNumericKey(key)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
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

// MARK: - DatePickerVCDelegate
extension ExpenseEditorVC: DatePickerVCDelegate {
    
    func datePickerDidSelectDate(date: NSDate) {
        self.expense.dateSpent = date
        self.refreshDateSpentDisplay()
    }
    
}
