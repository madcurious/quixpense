//
//  __EEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 13/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __EEVCView: UIView {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var fieldContainer: UIView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var paymentMethodContainer: UIView!
    @IBOutlet weak var noteContainer: UIView!
    
    @IBOutlet var fieldLabels: [UILabel]!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var keypadCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.topContainer,
            self.fieldContainer,
            self.categoryContainer,
            self.dateContainer,
            self.paymentMethodContainer,
            self.noteContainer
        )
        self.backgroundColor = Color.UniversalBackgroundColor
        self.keypadCollectionView.backgroundColor = Color.KeypadBackgroundColor
    }
    
}
