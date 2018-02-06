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
        
        editorView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
        editorView.categoryButton.addTarget(self, action: #selector(handleTapOnCategoryButton), for: .touchUpInside)
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
        DatePickerViewController.present(from: self, initialSelection: Date()) { (selectedDate) in
            self.editorView.dateButton.titleLabel.text = DateUtil.stringForExpenseEditor(for: selectedDate)
        }
    }
    
    func handleTapOnCategoryButton() {
        let categoryPicker = CategoryPickerViewController(viewContext: container.viewContext, initialSelection: nil)
        navigationController?.pushViewController(categoryPicker, animated: true)
    }
    
}
