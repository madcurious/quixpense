//
//  CategoryPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

fileprivate enum ViewID: String {
    case categoryCell = "CategoryCell"
    case addCategoryCell = "AddCategoryCell"
}

class CategoryPickerVC: UIViewController {
    
    let customView = __CategoryPickerVCView.instantiateFromNib()
    
    var categories = App.allCategories()
    var isTypingACategory = false
    
    let operationQueue = OperationQueue()
    
    init() {
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
        
        self.customView.tableView.register(CustomPickerCell.nib(), forCellReuseIdentifier: ViewID.categoryCell.rawValue)
        self.customView.tableView.register(CategoryPickerAddCategoryCell.self, forCellReuseIdentifier: ViewID.addCategoryCell.rawValue)
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        
        // Dismissal tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
        
        let system = NotificationCenter.default
        
        // Layout adjustments due to keyboard appearance
        system.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        system.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        system.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Text field notifications.
        system.addObserver(self, selector: #selector(handleTextFieldBeganEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        system.addObserver(self, selector: #selector(handleTextFieldTextChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        system.addObserver(self, selector: #selector(handleTextFieldFinishedEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
    }
    
    func runSearchOperation(searchText: String) {
        self.operationQueue.cancelAllOperations()
        self.operationQueue.addOperation(
            SearchCategoryOperation(searchText: searchText)
                .onStart({[unowned self] in
                    self.customView.tableView.isHidden = true
                    })
                .onReturn({[unowned self] in
                    self.customView.tableView.isHidden = false
                    })
                .onSuccess({[unowned self] result in
                    self.categories = result as! [Category]
                    self.customView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                    })
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions
extension CategoryPickerVC {
    
    func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = keyboardFrame.height
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = 0
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = keyboardFrame.height
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func handleTextFieldBeganEditing() {
        self.isTypingACategory = true
    }
    
    func handleTextFieldTextChanged() {
        if let searchText = md_nonEmptyString(self.customView.textField.text) {
            self.runSearchOperation(searchText: searchText)
        }
        self.customView.tableView.reloadData()
    }
    
    func handleTextFieldFinishedEditing() {
        self.isTypingACategory = false
        
        self.categories = App.allCategories()
        self.customView.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryPickerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isTypingACategory && md_nonEmptyString(self.customView.textField.text) != nil {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.isTypingACategory {
        case true where section == 0 &&
            md_nonEmptyString(self.customView.textField.text) != nil:
            return 1
            
        default:
            return self.categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.isTypingACategory {
        case true where indexPath.section == 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.addCategoryCell.rawValue) as! CategoryPickerAddCategoryCell
            cell.categoryName = self.customView.textField.text
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.categoryCell.rawValue) as! CustomPickerCell
            cell.itemLabel.text = self.categories[indexPath.row].name
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate
extension CategoryPickerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
