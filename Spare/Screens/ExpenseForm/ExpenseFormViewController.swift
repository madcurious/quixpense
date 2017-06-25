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
    
    var amountText: String {
        get {
            return self.customView.amountFieldView.textField.text ?? ""
        }
        set {
            self.customView.amountFieldView.textField.text = newValue
        }
    }
    
    var categoryText: String {
        get {
            return self.customView.categoryFieldView.textField.text ?? ""
        }
        set {
            self.customView.categoryFieldView.textField.text = newValue
        }
    }
    
    var tagText: String {
        get {
            return self.customView.tagFieldView.textField.text ?? ""
        }
        set {
            self.customView.tagFieldView.textField.text = newValue
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    @objc func handleTapOnCancelButton() {
        
    }
    
    @objc func handleTapOnDoneButton() {
        
    }
    
}
