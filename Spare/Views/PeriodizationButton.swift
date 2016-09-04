//
//  PeriodizationButton.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class PeriodizationButton: Button {
    
    var selectedPeriodization = App.state.selectedPeriodization
    
    override init() {
        super.init()
        self.updateText()
        self.addTarget(self, action: #selector(handleTap), forControlEvents: .TouchUpInside)
    }
    
    func handleTap() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let options: [Periodization] = [.Day, .Week, .Month, .Year]
        for i in 0 ..< options.count {
            let option = options[i]
            let action = UIAlertAction(title: option.descriptiveText, style: .Default, handler: {[unowned self] _ in
                self.selectPeriodization(option)
                })
            actionSheet.addAction(action)
        }
        actionSheet.addCancelAction()
        
        md_rootViewController().presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func selectPeriodization(periodization: Periodization) {
        if periodization == self.selectedPeriodization {
            return
        }
        self.selectedPeriodization = periodization
        self.updateText()
        self.sendActionsForControlEvents(.ValueChanged)
    }
    
    func updateText() {
        self.label.attributedText = NSAttributedString(string: self.selectedPeriodization.descriptiveText,
                                                       font: Font.ModalBarButtonText,
                                                       textColor: Color.UniversalTextColor)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
