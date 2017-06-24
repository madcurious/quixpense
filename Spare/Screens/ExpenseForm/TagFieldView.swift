//
//  TagFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 24/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class TagFieldView: UIView, Themeable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.imageView.image = UIImage.templateNamed("tagIcon")
        
        self.textField.autocapitalizationType = .none
    }
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.textColor = Global.theme.color(for: .regularText)
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "Tags",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.frame.contains(point) {
            return self.textField
        }
        return super.hitTest(point, with: event)
    }
    
}
