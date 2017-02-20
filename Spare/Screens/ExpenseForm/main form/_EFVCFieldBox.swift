//
//  _EFVCFieldBox.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCFieldBox: UIView, Themeable {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    
    /**
     The view that the user taps in order to enter a value (e.g., a button that launches
     a picker, a UITextField, or a UITextView).
     
     A subclass must supply this variable so that touch events beyond the its vertical bounds
     but within its horizontal bounds still allow the view to become the first responder.
     */
    var mainResponder: UIView {
        fatalError("This property must be supplied by a subclass.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyTheme()
        
        UIView.clearBackgroundColors(self, self.contentView)
        
        self.fieldLabel.font = Font.regular(12)
        self.fieldLabel.numberOfLines = 1
        self.fieldLabel.lineBreakMode = .byTruncatingTail
        
        self.separatorViewHeight.constant = 0.5
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) && // Common sense says this bool shouldn't be necessary but looks like an iOS bug.
            point.x >= self.mainResponder.frame.origin.x &&
            point.x <= (self.mainResponder.frame.origin.x + self.mainResponder.bounds.size.width) {
            return self.mainResponder
        }
        return super.hitTest(point, with: event)
    }
    
    func applyTheme() {
        self.iconImageView.tintColor = Global.theme.fieldIconColor
        self.fieldLabel.textColor = Global.theme.fieldNameTextColor
        self.separatorView.backgroundColor = Global.theme.tableViewSeparatorColor
    }
    
}
