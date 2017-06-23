//
//  DateFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class DateFieldView: UIView, Themeable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fieldStackView: UIStackView!
    
    @IBOutlet weak var dayContainer: UIView!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthContainer: UIView!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var textFieldLabels: [UILabel]!
    @IBOutlet var slashLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.imageView.image = UIImage.templateNamed("dateIcon")
        
        self.dayLabel.text = "DD"
        self.monthLabel.text = "MM"
        self.yearLabel.text = "YYYY"
        for slashLabel in self.slashLabels {
            slashLabel.text = "/"
        }
    }
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        
        for textField in self.textFields {
            textField.font = Global.theme.font(for: .regularText)
            textField.textColor = Global.theme.color(for: .regularText)
            textField.textAlignment = .center
        }
        self.dayTextField.attributedPlaceholder = NSAttributedString(
            string: "31",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        self.monthTextField.attributedPlaceholder = NSAttributedString(
            string: "12",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        self.yearTextField.attributedPlaceholder = NSAttributedString(
            string: "1990",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
        
        for slashLabel in self.slashLabels {
            slashLabel.font = Global.theme.font(for: .regularText)
            slashLabel.textColor = Global.theme.color(for: .regularText)
        }
        
        for textFieldLabel in self.textFieldLabels {
            textFieldLabel.font = Global.theme.font(for: .dateTextFieldLabel)
            textFieldLabel.textColor = Global.theme.color(for: .placeholder)
            textFieldLabel.textAlignment = .center
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = self.convert(point, to: self.fieldStackView)
        
        switch convertedPoint {
        case _ where self.yearContainer.frame.contains(convertedPoint):
            return self.yearTextField
        case _ where self.monthContainer.frame.contains(convertedPoint):
            return self.monthTextField
        case _ where self.frame.contains(point):
            return self.dayTextField
        default:
            return super.hitTest(point, with: event)
        }
    }
    
}
