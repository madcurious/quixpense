//
//  ExpenseFormViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseFormViewController: UIViewController {
    
    struct InputModel {
        var amountText: String?
        var selectedDate = Date()
        var selectedCategory = CategoryArgument.none
        var selectedTags = Set<TagArgument>()
    }
    
    let customView = ExpenseFormView.instantiateFromNib()
    var inputModel = InputModel()
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
        
        customView.categoryFieldView.editButton.addTarget(self, action: #selector(handleTapOnCategoryEditButton), for: .touchUpInside)
        customView.categoryFieldView.clearButton.addTarget(self, action: #selector(handleTapOnCategoryClearButton), for: .touchUpInside)
        
        customView.amountFieldView.textField.delegate = self
        customView.tagFieldView.textField.delegate = self
    }
    
    func hasUnsavedChanges() -> Bool {
        guard (inputModel.amountText?.isEmpty ?? true) == false ||
            inputModel.selectedCategory != .none ||
            inputModel.selectedTags.isEmpty == false
            else {
                return false
        }
        return true
    }
    
    func resetFields() {
        // Reset the input model.
        inputModel.amountText = nil
        inputModel.selectedDate = Date()
        inputModel.selectedCategory = .none
        inputModel.selectedTags.removeAll()
        
        // Reset the views.
        customView.amountFieldView.textField.text = nil
        customView.dateFieldView.setDate(inputModel.selectedDate)
        customView.categoryFieldView.setCategory(.none)
        customView.tagFieldView.textField.text = nil
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
    
    func handleTapOnCategoryEditButton() {
        CategoryPickerViewController.present(from: self, selectedCategory: inputModel.selectedCategory)
    }
    
    func handleTapOnCategoryClearButton() {
        inputModel.selectedCategory = .none
        customView.categoryFieldView.setCategory(.none)
    }
    
}

// MARK: - CategoryPickerViewControllerDelegate

extension ExpenseFormViewController: CategoryPickerViewControllerDelegate {
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategoryArgument) {
        // Update the model.
        inputModel.selectedCategory = category
        
        // Update the view.
        customView.categoryFieldView.setCategory(category)
    }
    
}

// MARK: - UITextFieldDelegate

extension ExpenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case customView.amountFieldView.textField:
            return true
            
        default:
            TagPickerViewController.present(from: self, selectedTags: nil)
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
                inputModel.amountText = {
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
