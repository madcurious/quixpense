//
//  ExpenseEditorView.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class ExpenseEditorView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var underlineViews: [UIView]!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var fieldLabels: [UILabel]!
    
    @IBOutlet weak var dateButton: BRLabelButton!
    @IBOutlet weak var categoryButton: BRLabelButton!
    @IBOutlet weak var tagsButton: BRLabelButton!
    
    let fieldLabelTexts = [
        Locale.current.currencyCode ?? "AMOUNT",
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
        
        if UIScreen.main.nativeSize.height > 568 {
            stackView.spacing = 20
        }
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
        
        amountTextField.font = .systemFont(ofSize: 30, weight: .semibold)
        
        underlineViews.forEach {
            $0.backgroundColor = .hex(0xeeeeee)
        }
        
        dateButton.tintColor = Palette.black
        
        categoryButton.enableTextFieldBehavior(placeholderText: "(optional)",
                                               placeholderTextColor: Palette.gray_cccccc,
                                               textColor: Palette.black)
        
        tagsButton.enableTextFieldBehavior(placeholderText: "(optional)",
                                           placeholderTextColor: Palette.gray_cccccc,
                                           textColor: Palette.black)
    }
    
}
