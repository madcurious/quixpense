//
//  ExpenseEditorViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class ExpenseEditorViewController: UIViewController {
    
    let editorView = ExpenseEditorView(frame: .zero)
    let container: NSPersistentContainer
    var rawExpense = RawExpense()
    
    init(container: NSPersistentContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unimplemented \(#function)")
    }
    
    override func loadView() {
        view = editorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleTapOnCancelButton))
        navigationItem.title = "Add Expense"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        editorView.dateButton.text = DateUtil.stringForExpenseEditor(for: rawExpense.dateSpent)
        editorView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
        editorView.categoryButton.addTarget(self, action: #selector(handleTapOnCategoryButton), for: .touchUpInside)
        editorView.tagsButton.addTarget(self, action: #selector(handleTapOnTagsButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editorView.amountTextField.becomeFirstResponder()
    }
    
}

@objc fileprivate extension ExpenseEditorViewController {
    
    func handleTapOnCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDateButton() {
        DatePickerViewController.present(from: self, initialSelection: rawExpense.dateSpent) { (selectedDate) in
            self.rawExpense.dateSpent = selectedDate
            self.editorView.dateButton.text = DateUtil.stringForExpenseEditor(for: selectedDate)
        }
    }
    
    func handleTapOnCategoryButton() {
        let categoryPicker = CategoryPickerViewController(viewContext: container.viewContext, initialSelection: editorView.categoryButton.text) {
            self.editorView.categoryButton.text = $0
        }
        navigationController?.pushViewController(categoryPicker, animated: true)
    }
    
    func handleTapOnTagsButton() {
        let tagPicker = TagPickerViewController(viewContext: container.viewContext)
        navigationController?.pushViewController(tagPicker, animated: true)
    }
    
}
