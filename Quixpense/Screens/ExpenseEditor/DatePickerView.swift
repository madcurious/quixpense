//
//  DatePickerView.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var currentBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStructure()
        applyTheme()
        setupFunctionality()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStructure()
        applyTheme()
        setupFunctionality()
    }
    
    func setupStructure() {
        let viewFromNib = viewFromOwnedNib()
        viewFromNib.performRecursively { $0.backgroundColor = .clear }
        addSubviewAndFill(viewFromNib)
        
        toolBar.isTranslucent = false
    }
    
    func applyTheme() {
        dimView.backgroundColor = Palette.black
        pickerContainerView.backgroundColor = Palette.white
    }
    
    func setupFunctionality() {
        currentBarButtonItem.target = self
        currentBarButtonItem.action = #selector(handleTapOnCurrentBarButtonItem)
    }
    
}

@objc fileprivate extension DatePickerView {
    
    func handleTapOnCurrentBarButtonItem() {
        pickerView.setDate(Date(), animated: true)
    }
    
}
