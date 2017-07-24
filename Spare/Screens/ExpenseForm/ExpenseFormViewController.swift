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
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(
            .cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(
            .done, target: self, action: #selector(handleTapOnDoneButton))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapGestureRecognizer)
        
        self.customView.amountFieldView.textField.delegate = self
        self.customView.categoryFieldView.textField.delegate = self
        self.customView.tagFieldView.textField.delegate = self
    }
    
    func hasUnsavedChanges() -> Bool {
        guard (self.inputModel.amountText?.isEmpty ?? true) == false ||
            self.inputModel.selectedCategory != .none ||
            self.inputModel.selectedTags.isEmpty == false
            else {
                return false
        }
        return true
    }
    
    func resetFields() {
        // Reset the input model.
        self.inputModel.amountText = nil
        self.inputModel.selectedDate = Date()
        self.inputModel.selectedCategory = .none
        self.inputModel.selectedTags.removeAll()
        
        // Reset the views.
        self.customView.amountFieldView.textField.text = nil
        self.customView.dateFieldView.setDate(self.inputModel.selectedDate)
        self.customView.categoryFieldView.textField.text = nil
        self.customView.tagFieldView.textField.text = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions

extension ExpenseFormViewController {
    
    @objc func handleTapOnView() {
        self.customView.endEditing(true)
    }
    
    @objc func handleTapOnCancelButton() {
        
    }
    
    @objc func handleTapOnDoneButton() {
        
    }
    
}

// MARK: - CategoryPickerViewControllerDelegate

extension ExpenseFormViewController: CategoryPickerViewControllerDelegate {
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategoryArgument) {
        switch category {
        case .id(let objectID):
            self.customView.categoryFieldView.textField.text = {
                guard let category = Global.coreDataStack.viewContext.object(with: objectID) as? Category,
                    let categoryName = category.name
                    else {
                        return nil
                }
                return categoryName
            }()
            
        case .name(let name):
            self.customView.categoryFieldView.textField.text = name
            
        case .none:
            self.customView.categoryFieldView.textField.text = nil
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ExpenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.customView.amountFieldView.textField:
            return true
            
        case self.customView.categoryFieldView.textField:
            CategoryPickerViewController.present(from: self, selectedCategory: .none)
            return false
            
        default:
            TagPickerViewController.present(from: self, selectedTags: nil)
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Don't allow text editing if the text replacement contains invalid characters.
        if textField == self.customView.amountFieldView.textField,
            let _ = string.rangeOfCharacter(from: self.invalidAmountCharacters) {
            return false
        }
        
        switch textField {
        case self.customView.amountFieldView.textField:
            if let _ = string.rangeOfCharacter(from: self.invalidAmountCharacters) {
                return false
            } else {
                self.inputModel.amountText = {
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
