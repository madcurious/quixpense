//
//  ExpenseEditorViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseEditorViewController: UIViewController {
    
    let editorView = ExpenseEditorView(frame: .zero)
    
    override func loadView() {
        view = editorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleTapOnCancelButton))
        navigationItem.title = "Add Expense"
        
        editorView.dateButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
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
        DatePickerViewController.present(from: self)
    }
    
}
