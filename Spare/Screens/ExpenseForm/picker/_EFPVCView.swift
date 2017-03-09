//
//  _EFPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class _EFPVCView: UIView, Themeable {
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var titleBar: UIView!
    @IBOutlet weak var titleBarHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var pickerViewContainer: UIView!
    
    var pickerViewContainerHeight: CGFloat {
        get {
            return self.contentViewHeight.constant - (self.titleBarHeight.constant + self.titleBarBottom.constant)
        }
        set {
            self.contentViewHeight.constant = self.titleBarHeight.constant + self.titleBarBottom.constant + newValue
            self.setNeedsLayout()
        }
    }
    
    @IBOutlet weak var cancelButton: MDImageButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: MDImageButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var dimViewMaxAlpha: CGFloat {
        return 0.5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.contentView, self.cancelButton, self.doneButton)
        
        self.dimView.backgroundColor = UIColor.black
        
        self.cancelButton.image = UIImage.templateNamed("Cancel")
        self.doneButton.image = UIImage.templateNamed("Done")
        
        self.titleLabel.font = Font.bold(17)
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.textAlignment = .center
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.cancelButton.tintColor = Global.theme.color(for: .barTint)
        self.doneButton.tintColor = Global.theme.color(for: .barTint)
        self.titleLabel.textColor = Global.theme.color(for: .barTint)
    }
    
}
