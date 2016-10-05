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
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    func handleTap() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let options: [Periodization] = [.day, .week, .month, .year]
        for i in 0 ..< options.count {
            let option = options[i]
            let action = UIAlertAction(title: option.descriptiveText, style: .default, handler: {[unowned self] _ in
                self.selectPeriodization(option)
                })
            actionSheet.addAction(action)
        }
        actionSheet.addCancelAction()
        
        md_rootViewController().present(actionSheet, animated: true, completion: nil)
    }
    
    func selectPeriodization(_ periodization: Periodization) {
        if periodization == self.selectedPeriodization {
            return
        }
        self.selectedPeriodization = periodization
        self.updateText()
        self.sendActions(for: .valueChanged)
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
