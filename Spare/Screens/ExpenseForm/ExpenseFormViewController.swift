//
//  ExpenseFormViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseFormViewController: UIViewController {
    
    let customView = ExpenseFormView.instantiateFromNib()
    var selectedCategory: Category?
    var selectedTags: Set<Tag>?
    
    var amountText: String? {
        get {
            return self.customView.amountFieldView.textField.text?.trim()
        }
        set {
            self.customView.amountFieldView.textField.text = newValue
        }
    }
    
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
        
        self.customView.categoryFieldView.textField.delegate = self
        self.customView.tagFieldView.textField.delegate = self
    }
    
    func hasUnsavedChanges() -> Bool {
        guard (self.amountText?.isEmpty ?? true) == false ||
            self.selectedCategory != nil ||
            self.selectedTags != nil
            else {
                return false
        }
        return true
    }
    
    func resetFields() {
        self.customView.amountFieldView.textField.text = nil
        self.customView.dateFieldView.setToCurrentDate()
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
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: Category) {
        self.selectedCategory = category
        self.customView.categoryFieldView.textField.text = category.name
    }
    
    func categoryPicker(_ picker: CategoryPickerViewController, didAddNewCategoryName name: String) {
        self.customView.categoryFieldView.textField.text = name
    }
    
}

// MARK: - UITextFieldDelegate

extension ExpenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.customView.categoryFieldView.textField:
            CategoryPickerViewController.present(from: self, selectedCategoryID: nil)
        default:
            TagPickerViewController.present(from: self, selectedTags: nil)
        }
        return false
    }
    
}
