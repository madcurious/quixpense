//
//  NewClassifierViewController.swift
//  Spare
//
//  Created by Matt Quiros on 10/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class NewClassifierViewController: UIViewController {
    
    let classifierType: ClassifierType
    let successAction: (String) -> ()
    
    lazy var customView = NewClassifierView.instantiateFromNib()
    
    init(classifierType: ClassifierType, successAction: @escaping (String) -> ()) {
        self.classifierType = classifierType
        self.successAction = successAction
        super.init(nibName: nil, bundle: nil)
        
        switch classifierType {
        case .category:
            self.title = "New Category"
        case .tag:
            self.title = "New Tag"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customView.textField.becomeFirstResponder()
    }
    
}

@objc extension NewClassifierViewController {
    
    func handleTapOnCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleTapOnDoneButton() {
        guard let text = self.customView.textField.text?.trim()
            else {
                return
        }
        
        if text.isEmpty == true {
            MDAlertDialog.showInPresenter(self, title: nil, message: "You must enter a \(self.classifierType.description) name.", cancelButtonTitle: "Got it!")
        } else {
            self.successAction(text)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
