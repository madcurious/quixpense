//
//  _EFPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class _EFPVCView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var titleBar: UIView!
    
    @IBOutlet weak var cancelButton: MDImageButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: MDImageButton!
    
    @IBOutlet weak var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.dimView.backgroundColor = UIColor.black
        self.dimView.alpha = 0.3
        
        self.cancelButton.image = UIImage.templateNamed("Cancel")
        self.cancelButton.tintColor = Global.theme.barTintColor
        
        self.doneButton.image = UIImage.templateNamed("Done")
        self.cancelButton.tintColor = Global.theme.barTintColor
    }
    
}
