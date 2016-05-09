//
//  BaseFormVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class BaseFormVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCancelAndDoneBarButtonItems("CANCEL", doneButtonTitle: "SAVE")
        
        let barButtonAttributes = [
            NSFontAttributeName: Font.BarButtonItems,
            NSForegroundColorAttributeName: Color.White
        ]
        if let leftBarButtonItem = self.navigationItem.leftBarButtonItem {
            leftBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
            rightBarButtonItem.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = Color.White
        titleLabel.font = Font.NavigationBarTitle
        titleLabel.text = self.title
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
}