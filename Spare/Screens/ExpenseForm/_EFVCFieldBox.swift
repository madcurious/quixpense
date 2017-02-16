//
//  _EFVCFieldBox.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCFieldBox: UIView {
    
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
        
        UIView.clearBackgroundColors(self, self.contentView)
        
        self.fieldLabel.font = Font.regular(10)
        self.fieldLabel.textColor = Global.theme.fieldLabelTextColor
        self.fieldLabel.numberOfLines = 1
        self.fieldLabel.lineBreakMode = .byTruncatingTail
        
        self.separatorView.backgroundColor = Global.theme.tableViewSeparatorColor
        self.separatorViewHeight.constant = 0.5
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if point.x >= self.mainResponder.frame.origin.x &&
            point.x <= (self.mainResponder.frame.origin.x + self.mainResponder.bounds.size.width) {
            return self.mainResponder
        }
        return super.hitTest(point, with: event)
    }
    
}
