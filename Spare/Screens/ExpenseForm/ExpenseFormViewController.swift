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
        var selectedCategory = CategorySelection.none
        var selectedTags = TagSelection.none
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
        
        customView.tagFieldView.editButton.addTarget(self, action: #selector(handleTapOnTagEditButton), for: .touchUpInside)
        
        customView.amountFieldView.textField.delegate = self
    }
    
    func hasUnsavedChanges() -> Bool {
        if inputModel.amountText != nil {
            return true
        }
        
        if let amountText = inputModel.amountText,
            amountText.isEmpty == false {
            return true
        }
        
        if inputModel.selectedCategory != .none {
            return true
        }
        
        if case .set(let set) = inputModel.selectedTags,
            set.isEmpty == false {
            return true
        }
        
        return false
    }
    
    func resetFields() {
        // Reset the input model.
        inputModel.amountText = nil
        inputModel.selectedDate = Date()
        inputModel.selectedCategory = .none
        inputModel.selectedTags = .none
        
        // Reset the views.
        customView.amountFieldView.textField.text = nil
        customView.dateFieldView.setDate(inputModel.selectedDate)
        customView.categoryFieldView.setCategory(.none)
        customView.tagFieldView.setTags(.none)
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
    
    func handleTapOnTagEditButton() {
        TagPickerViewController.present(from: self, selectedTags: inputModel.selectedTags)
    }
    
    func handleTapOnTagClearButton() {
        inputModel.selectedTags = .none
        customView.tagFieldView.setTags(.none)
    }
    
}

// MARK: - CategoryPickerViewControllerDelegate

extension ExpenseFormViewController: CategoryPickerViewControllerDelegate {
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategorySelection) {
        // Update the model.
        inputModel.selectedCategory = category
        
        // Update the view.
        customView.categoryFieldView.setCategory(category)
    }
    
}

// MARK: - TagPickerViewControllerDelegate

extension ExpenseFormViewController: TagPickerViewControllerDelegate {
    
    func tagPicker(_ picker: TagPickerViewController, didSelectTags tags: TagSelection) {
        inputModel.selectedTags = tags
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
