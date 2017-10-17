//
//  NewClassifierViewController.swift
//  Spare
//
//  Created by Matt Quiros on 10/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

protocol NewClassifierViewControllerDelegate {
    func newClassifierViewController(_ newClassifierViewController: NewClassifierViewController, didEnter classifierName: String?)
}

class NewClassifierViewController: UIViewController {
    
    let classifierType: ClassifierType
    var delegate: NewClassifierViewControllerDelegate?
    
    lazy var customView = NewClassifierView.instantiateFromNib()
    
    init(classifierType: ClassifierType) {
        self.classifierType = classifierType
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
        
        let classifierPlural: String = {
            if self.classifierType == .category {
                return "categories"
            }
            return "tags"
        }()
        self.customView.footerLabel.text = "New \(classifierPlural) are saved when the expense is saved."
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
        if let delegate = delegate {
            delegate.newClassifierViewController(self, didEnter: customView.textField.text)
        }
    }
    
}
