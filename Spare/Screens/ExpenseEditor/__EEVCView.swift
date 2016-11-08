//
//  __EEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 13/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

fileprivate let kIconBackgroundViewWidth = CGFloat(50)

class __EEVCView: UIView {
    
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var upperFormContainer: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var fieldContainer: UIView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var paymentMethodContainer: UIView!
    @IBOutlet weak var subcategoriesContainer: UIView!
    @IBOutlet weak var noteContainer: UIView!
    @IBOutlet weak var amountContainer: UIView!
    
    @IBOutlet var iconContainers: [UIView]!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var subcategoriesImageView: UIImageView!
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paymentMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var subcategoriesButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    @IBOutlet weak var keypadCollectionView: UICollectionView!
    
    @IBOutlet weak var iconBackgroundViewWidth: NSLayoutConstraint!
    
    
    var amountText: String? {
        didSet {
            defer {
                self.setNeedsLayout()
                
                if let amountText = self.amountText {
                    self.amountLabel.text = amountText
                } else {
                    self.amountLabel.text = "0"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.formContainer,
            self.upperFormContainer,
            self.fieldContainer,
            self.categoryContainer,
            self.dateContainer,
            self.paymentMethodContainer,
            self.subcategoriesContainer,
            self.noteContainer,
            self.amountContainer
        )
        UIView.clearBackgroundColors(self.iconContainers)
        
        self.backgroundColor = Color.UniversalBackgroundColor
        self.iconBackgroundView.backgroundColor = UIColor(hex: 0x000000)
        self.keypadCollectionView.backgroundColor = UIColor(hex: 0x222222)
        
        let textFields = [self.noteTextField!]
        let placeholders = ["Note (optional)"]
        for i in 0 ..< textFields.count {
            let textField = textFields[i]
            textField.font = Font.make(.regular, 17)
            textField.textColor = Color.FieldValueTextColor
            textField.attributedPlaceholder = NSAttributedString(string: placeholders[i], font: Font.make(.regular, 17), textColor: Color.FieldPlaceholderTextColor)
            textField.adjustsFontSizeToFitWidth = false
        }
        
        let imageViews = [self.categoryImageView, self.dateImageView, self.paymentMethodImageView, self.subcategoriesImageView, self.noteImageView]
        let imageNames = ["categoryIcon", "dateIcon", "paymentMethodIcon", "subcategoriesIcon", "noteIcon"]
        for i in 0 ..< imageViews.count {
            guard let imageView = imageViews[i]
                else {
                    continue
            }
            imageView.image = UIImage.templateNamed(imageNames[i])
            imageView.tintColor = UIColor(hex: 0x666666)
        }
        
        let buttons = [self.categoryButton, self.dateButton, self.subcategoriesButton]
        for button in buttons {
            button?.tintColor = Color.FieldValueTextColor
            button?.titleLabel?.font = Font.make(.regular, 17)
            button?.contentHorizontalAlignment = .left
            button?.titleLabel?.numberOfLines = 1
            button?.titleLabel?.lineBreakMode = .byTruncatingTail
        }
        
        self.paymentMethodSegmentedControl.tintColor = Color.UniversalTextColor
        self.paymentMethodSegmentedControl.setTitleTextAttributes([NSFontAttributeName : Font.make(.regular, 17)], for: .normal)
        for i in 0 ..< PaymentMethod.allValues.count {
            self.paymentMethodSegmentedControl.setTitle(PaymentMethod.allValues[i].text, forSegmentAt: i)
        }
        
        self.currencyLabel.textColor = UIColor(hex: 0x666666)
        self.currencyLabel.text = AmountFormatter.currencySymbol()
        self.currencyLabel.font = Font.make(.bold, 24)
        self.currencyLabel.textAlignment = .center
        
        self.amountLabel.textColor = Color.FieldValueTextColor
        self.amountLabel.font = {
            if MDScreen.sizeIsAtLeast(.iPhone5) {
                return Font.make(.bold, 17)
            }
            return Font.make(.bold, 24)
        }()
        self.amountLabel.adjustsFontSizeToFitWidth = true
        self.amountLabel.textAlignment = .left
        self.amountLabel.numberOfLines = 1
        self.amountLabel.lineBreakMode = .byClipping
        
        self.keypadCollectionView.isScrollEnabled = false
        self.keypadCollectionView.allowsSelection = true
        
        self.setNeedsUpdateConstraints()
    }
    
}
