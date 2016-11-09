//
//  ExpenseEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 03/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

private enum ViewID: String {
    case KeypadCell = "KeypadCell"
}

private let kPeriod = "."

/**
 Editor used for adding or editing an expense.
 
 The amount is derived from the property `unformattedAmount`, which is simply the sequence of keys that
 were pressed in the custom keypad.
 */
class ExpenseEditorVC: UIViewController {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    
    var managedObjectContext = App.coreDataStack.newBackgroundContext()
    var expense: Expense
    
    let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", kPeriod, "0", Icon.ExpenseEditorBackspace.rawValue]
    let amountFormatter = NumberFormatter()
    dynamic var unformattedAmount = ""
    
    let customPickerAnimator = CustomPickerTransitioningDelegate()
    
    init(expense: Expense?) {
        if let objectID = expense?.objectID,
            let expense = self.managedObjectContext.object(with: objectID) as? Expense {
            self.expense = expense
        } else {
            // If adding an expense, by default, the date is the current date and
            // the payment method is cash.
            self.expense = Expense(context: self.managedObjectContext)
            self.expense.dateSpent = Date() as NSDate
            self.expense.paymentMethod = PaymentMethod.cash.rawValue as NSNumber
        }
        
        super.init(nibName: nil, bundle: nil)
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
        
        self.addObserver(self, forKeyPath: #keyPath(ExpenseEditorVC.unformattedAmount), options: [.initial, .new], context: nil)
        self.setupKVO(for: self.expense)
        
        // Expense.note is the only field without KVO so set the text field.
        if let note = md_nonEmptyString(self.expense.note) {
            self.customView.noteTextField.text = note
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.customView.keypadCollectionView.dataSource = self
        self.customView.keypadCollectionView.delegate = self
        self.customView.keypadCollectionView.register(__EEVCKeypadCell.self, forCellWithReuseIdentifier: ViewID.KeypadCell.rawValue)
        
        self.customView.categoryButton.addTarget(self, action: #selector(handleTapOnCategoryButton), for: .touchUpInside)
        self.customView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
        self.customView.paymentMethodSegmentedControl.addTarget(self, action: #selector(handleChangeOnPaymentMethod), for: .valueChanged)
        self.customView.subcategoriesButton.addTarget(self, action: #selector(handleTapOnSubcategoriesButton), for: .touchUpInside)
        
        self.customView.noteTextField.delegate = self
    }
    
    func reset() {
        self.removeKVO(for: self.expense)
        
        // Reset the model, but leave the date, category, and payment method the same.
        let previousDate = self.expense.dateSpent
        let previousCategory = self.expense.category
        let previousPaymentMethod = self.expense.paymentMethod
        
        let expense = Expense(context: self.managedObjectContext)
        expense.dateSpent = previousDate
        expense.category = previousCategory
        expense.paymentMethod = previousPaymentMethod
        expense.note = nil
        expense.amount = nil
        self.expense = expense
        self.setupKVO(for: self.expense)
        
        self.unformattedAmount = ""
        
        self.amountFormatter.alwaysShowsDecimalSeparator = false
        self.amountFormatter.minimumFractionDigits = 0
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(ExpenseEditorVC.unformattedAmount))
        self.removeKVO(for: self.expense)
    }
    
}

// MARK: - KVO
extension ExpenseEditorVC {
    
    func setupKVO(for expense: Expense) {
        expense.addObserver(self, forKeyPath: #keyPath(Expense.category), options: [.initial, .new], context: nil)
        expense.addObserver(self, forKeyPath: #keyPath(Expense.dateSpent), options: [.initial, .new], context: nil)
        expense.addObserver(self, forKeyPath: #keyPath(Expense.subcategories), options: [.initial, .new], context: nil)
    }
    
    func removeKVO(for expense: Expense) {
        expense.removeObserver(self, forKeyPath: #keyPath(Expense.category))
        expense.removeObserver(self, forKeyPath: #keyPath(Expense.dateSpent))
        expense.removeObserver(self, forKeyPath: #keyPath(Expense.subcategories))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath
            else {
                return
        }
        
        switch keyPath {
        case "unformattedAmount":
            self.handleUpdateOnUnformattedAmount()
            
        case "category":
            self.handleUpdateOnCategory(newValue: change?[.newKey] as? Category)
            
        case "dateSpent":
            self.handleUpdateOnDateSpent(newValue: change?[.newKey] as? Date)
            
        case "subcategories":
            self.handleUpdateOnSubcategories()
            
        default:
            return
        }
    }
    
    func handleUpdateOnCategory(newValue: Category?) {
        if let category = newValue,
            let categoryName = category.name {
            self.customView.categoryButton.setTitle(categoryName, for: .normal)
            self.customView.categoryButton.setTitleColor(Color.FieldValueTextColor, for: .normal)
        } else {
            self.customView.categoryButton.setTitle("Add a category (required)", for: .normal)
            self.customView.categoryButton.setTitleColor(Color.FieldPlaceholderTextColor, for: .normal)
        }
    }
    
    func handleUpdateOnUnformattedAmount() {
        guard self.unformattedAmount.isEmpty == false
            else {
                self.expense.amount = nil
                self.customView.amountText = nil
                self.amountFormatter.alwaysShowsDecimalSeparator = false
                self.amountFormatter.minimumFractionDigits = 0
                return
        }
        
        let characters = self.unformattedAmount.characters
        if let indexOfPeriod = characters.index(of: Character(kPeriod)) {
            self.amountFormatter.alwaysShowsDecimalSeparator = true
            self.amountFormatter.minimumFractionDigits = characters.distance(from: indexOfPeriod, to: characters.endIndex) - 1
        } else {
            self.amountFormatter.alwaysShowsDecimalSeparator = false
            self.amountFormatter.minimumFractionDigits = 0
        }
        
        let amountDecimalNumber = NSDecimalNumber(string: self.unformattedAmount)
        self.expense.amount = amountDecimalNumber
        self.customView.amountText = self.amountFormatter.string(from: amountDecimalNumber)
    }
    
    func handleUpdateOnDateSpent(newValue: Date?) {
        self.customView.dateButton.setTitle(DateFormatter.displayTextForExpenseEditorDate(newValue), for: .normal)
    }
    
    func handleUpdateOnSubcategories() {
        if let subcategories = self.expense.subcategories,
            subcategories.count > 0 {
            self.customView.subcategoriesButton.setTitle("DEBUG list here...", for: .normal)
            self.customView.subcategoriesButton.setTitleColor(Color.FieldValueTextColor, for: .normal)
        } else {
            self.customView.subcategoriesButton.setTitle("Subcategories (optional)", for: .normal)
            self.customView.subcategoriesButton.setTitleColor(Color.FieldPlaceholderTextColor, for: .normal)
        }
    }
    
}

// MARK: - Target actions
extension ExpenseEditorVC {
    
    func handleTapOnCategoryButton() {
        let picker = CategoryPickerVC()
        picker.delegate = self
        picker.setCustomTransitioningDelegate(self.customPickerAnimator)
        self.present(picker, animated: true, completion: nil)
    }
    
    func handleTapOnDateButton() {
        let datePicker = DatePickerVC(selectedDate: self.expense.dateSpent! as Date, delegate: self)
        datePicker.setCustomTransitioningDelegate(self.customPickerAnimator)
        self.present(datePicker, animated: true, completion: nil)
    }
    
    func handleChangeOnPaymentMethod() {
        let selectedIndex = self.customView.paymentMethodSegmentedControl.selectedSegmentIndex
        self.expense.paymentMethod = NSNumber(value: selectedIndex)
    }
    
    func handleTapOnSubcategoriesButton() {
        
    }
    
}

// MARK: - CategoryPickerVCDelegate
extension ExpenseEditorVC: CategoryPickerVCDelegate {
    
    func categoryPickerDidTapAddCategory(categoryName: String) {
        /*
         New categories are only saved if the expense itself was saved. Otherwise, they
         should be deleted.
         
         A category that does not exist in the main queue's MOC is a category that
         was added but not saved, so it should be deleted.
         */
        if let category = self.expense.category,
            App.allCategories.contains(category) == false {
            self.managedObjectContext.delete(category)
        }
        
        let category = Category(entity: Category.entity(), insertInto: self.managedObjectContext)
        category.name = categoryName
        self.expense.category = category
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func categoryPickerDidSelectCategory(category: Category) {
        self.expense.category = self.managedObjectContext.object(with: category.objectID) as? Category
        self.dismiss(animated: true, completion: nil)
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
            
        case Icon.ExpenseEditorBackspace.rawValue:
            guard self.unformattedAmount.isEmpty == false
                else {
                    return
            }
            
            // Actually remove the last character.
            self.unformattedAmount.remove(at: self.unformattedAmount.characters.index(self.unformattedAmount.endIndex, offsetBy: -1))
            return
            
        case kPeriod:
            guard self.unformattedAmount.contains(kPeriod) == false
                else {
                    return
            }
            fallthrough
            
        default:
            self.unformattedAmount += key
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
        self.expense.dateSpent = date as NSDate
    }
    
}

// MARK: - UITextFieldDelegate
extension ExpenseEditorVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.customView.noteTextField:
            let newText = ((self.customView.noteTextField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            self.expense.note = newText
            
        default:
            return false
        }
        
        return true
    }
    
}
