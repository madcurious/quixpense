//
//  ExpenseFormViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class ExpenseFormViewController: UIViewController {
    
    let customView = ExpenseFormView.instantiateFromNib()
    var rawExpense = RawExpense()
    let invalidAmountCharacters = CharacterSet.decimalNumberCharacterSet().inverted
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = BarButtonItems.make(
            .cancel, target: self, action: #selector(handleTapOnCancelButton))
        navigationItem.rightBarButtonItem = BarButtonItems.make(
            .done, target: self, action: #selector(handleTapOnDoneButton))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        tapGestureRecognizer.cancelsTouchesInView = false
        customView.addGestureRecognizer(tapGestureRecognizer)
        
        customView.dateFieldView.editButton.addTarget(self, action: #selector(handleTapOnDateEditButton), for: .touchUpInside)
        customView.dateFieldView.refreshButton.addTarget(self, action: #selector(handleTapOnDateRefreshButton), for: .touchUpInside)
        
        customView.categoryFieldView.editButton.addTarget(self, action: #selector(handleTapOnCategoryEditButton), for: .touchUpInside)
        customView.categoryFieldView.clearButton.addTarget(self, action: #selector(handleTapOnCategoryClearButton), for: .touchUpInside)
        
        customView.tagFieldView.editButton.addTarget(self, action: #selector(handleTapOnTagEditButton), for: .touchUpInside)
        customView.tagFieldView.clearButton.addTarget(self, action: #selector(handleTapOnTagClearButton), for: .touchUpInside)
        
        customView.amountFieldView.textField.delegate = self
    }
    
    func hasUnsavedChanges() -> Bool {
        if rawExpense.amount != nil {
            return true
        }
        
        if let amountText = rawExpense.amount,
            amountText.isEmpty == false {
            return true
        }
        
        if rawExpense.categorySelection != .none {
            return true
        }
        
        if case .list(let list) = rawExpense.tagSelection,
            list.isEmpty == false {
            return true
        }
        
        return false
    }
    
    func resetFields() {
        // Reset the input model.
        rawExpense.amount = nil
        rawExpense.dateSpent = Date()
        rawExpense.categorySelection = .none
        rawExpense.tagSelection = .none
        
        // Reset the views.
        customView.amountFieldView.textField.text = nil
        customView.dateFieldView.setDate(rawExpense.dateSpent)
        customView.categoryFieldView.setCategory(.none)
        customView.tagFieldView.setTags(.none)
    }
    
    func validateExpense(completion: @escaping (ValidExpense) -> Void) {
        let validateOp = ValidateExpenseOperation(rawExpense: rawExpense, context: Global.coreDataStack.viewContext) { [weak self] (result) in
            guard let weakSelf = self,
                let result = result
                else {
                    return
            }
            switch result {
            case .success(let validExpense):
                completion(validExpense)
            case .error(let error):
                DispatchQueue.main.async {
                    BRAlertDialog.showInPresenter(weakSelf, title: "Error", message: error.errorDescription, cancelButtonTitle: "Got it!")
                }
            }
        }
        BRDispatch.asyncRunInBackground {
            validateOp.start()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions

@objc extension ExpenseFormViewController {
    
    func handleTapOnView() {
        customView.endEditing(true)
    }
    
    func handleTapOnCancelButton() {
        
    }
    
    func handleTapOnDoneButton() {
        
    }
    
    func handleTapOnDateEditButton() {
        DatePickerViewController.present(from: self, selectedDate: rawExpense.dateSpent)
    }
    
    func handleTapOnDateRefreshButton() {
        let currentDate = Date()
        rawExpense.dateSpent = currentDate
        customView.dateFieldView.setDate(currentDate)
    }
    
    func handleTapOnCategoryEditButton() {
        CategoryPickerViewController.present(from: self, selectedCategory: rawExpense.categorySelection)
    }
    
    func handleTapOnCategoryClearButton() {
        rawExpense.categorySelection = .none
        customView.categoryFieldView.setCategory(.none)
    }
    
    func handleTapOnTagEditButton() {
        TagPickerViewController.present(from: self, selectedTags: rawExpense.tagSelection)
    }
    
    func handleTapOnTagClearButton() {
        rawExpense.tagSelection = .none
        customView.tagFieldView.setTags(.none)
    }
    
}

// MARK: - DatePickerViewControllerDelegate

extension ExpenseFormViewController: DatePickerViewControllerDelegate {
    
    func datePicker(_ datePicker: DatePickerViewController, didSelectDate date: Date) {
        rawExpense.dateSpent = date
        customView.dateFieldView.setDate(date)
    }
    
}

// MARK: - CategoryPickerViewControllerDelegate

extension ExpenseFormViewController: CategoryPickerViewControllerDelegate {
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategorySelection) {
        // Update the model.
        rawExpense.categorySelection = category
        
        // Update the view.
        customView.categoryFieldView.setCategory(category)
    }
    
}

// MARK: - TagPickerViewControllerDelegate

extension ExpenseFormViewController: TagPickerViewControllerDelegate {
    
    func tagPicker(_ picker: TagPickerViewController, didSelectTags tags: TagSelection) {
        rawExpense.tagSelection = tags
        customView.tagFieldView.setTags(tags)
    }
    
}

// MARK: - UITextFieldDelegate

extension ExpenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case customView.amountFieldView.textField:
            return true
            
        default:
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Don't allow text editing if the text replacement contains invalid characters.
        if textField == customView.amountFieldView.textField,
            let _ = string.rangeOfCharacter(from: invalidAmountCharacters) {
            return false
        }
        
        switch textField {
        case customView.amountFieldView.textField:
            if let _ = string.rangeOfCharacter(from: invalidAmountCharacters) {
                return false
            } else {
                rawExpense.amount = {
                    guard let existingText = textField.text as NSString?
                        else {
                            return nil
                    }
                    return existingText.replacingCharacters(in: range, with: string)
                }()
                return true
            }
            
        default:
            return true
        }
    }
    
}
