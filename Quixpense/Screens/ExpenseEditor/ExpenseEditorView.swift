//
//  ExpenseEditorView.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseEditorView: UIView {
    
    @IBOutlet var underlineViews: [UIView]!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var fieldLabels: [UILabel]!
    
    let fieldLabelTexts = [
        "PHP",
        "DATE",
        "CATEGORY",
        "TAGS"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStructure()
        applyTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStructure()
        applyTheme()
    }
    
    func setupStructure() {
        let viewFromNib = viewFromOwnedNib()
        viewFromNib.performRecursively { $0.backgroundColor = .clear }
        addSubviewAndFill(viewFromNib)
        
        for i in 0 ..< fieldLabelTexts.count {
            fieldLabels[i].text = fieldLabelTexts[i]
        }
        fieldLabels.first?.textAlignment = .center
        
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
    }
    
    func applyTheme() {
        backgroundColor = Palette.white
        underlineViews.forEach {
            $0.backgroundColor = Palette.gray_666666
        }
        
        fieldLabels.forEach {
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
            $0.textColor = Palette.gray_aaaaaa
        }
        
        amountTextField.font = .systemFont(ofSize: 26, weight: .semibold)
        
        underlineViews.forEach {
            $0.backgroundColor = .hex(0xeeeeee)
        }
    }
    
}
