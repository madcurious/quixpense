//
//  AddModalVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class AddModalVC: BaseVC {
    
    let addExpenseVC = EditExpenseVC()
    let addCategoryVC = EditCategoryVC(category: nil)
    let customView = __AMVCView.instantiateFromNib() as __AMVCView
    let titleLabel = UILabel()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.addExpenseVC, toView: self.customView.contentView, fillSuperview: false)
        self.embedChildViewController(self.addCategoryVC, toView: self.customView.contentView, fillSuperview: false)
        self.customView.setupLayoutRulesForPages(self.addExpenseVC.view, secondPage: self.addCategoryVC.view)
        
        // Setup the bar button items.
        self.addCancelAndDoneBarButtonItems("CLOSE", doneButtonTitle: "SAVE")
        let barButtonAttributes = [
            NSFontAttributeName: Font.get(.Bold, size: 14),
            NSForegroundColorAttributeName: Color.White
        ]
        if let leftBarButtonItem = self.navigationItem.leftBarButtonItem {
            leftBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
            rightBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        
        self.titleLabel.textColor = Color.White
        self.titleLabel.font = Font.get(.Bold, size: 18)
        self.titleLabel.text = "NEW EXPENSE"
        self.titleLabel.sizeToFit()
        self.navigationItem.titleView = self.titleLabel
        
        self.customView.pageControl.addTarget(self, action: #selector(handlePageChange(_:)), forControlEvents: .ValueChanged)
    }
    
    func handlePageChange(sender: AnyObject) {
        guard let pageControl = sender as? UIPageControl
            else {
                return
        }
        
        self.titleLabel.text = {
            switch pageControl.currentPage {
            case 0:
                return "NEW EXPENSE"
            default:
                return "NEW CATEGORY"
            }
        }()
        self.titleLabel.sizeToFit()
    }
    
}

