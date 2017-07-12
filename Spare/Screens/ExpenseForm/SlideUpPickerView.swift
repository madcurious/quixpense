//
//  SlideUpPickerView.swift
//  Spare
//
//  Created by Matt Quiros on 11/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class SlideUpPickerView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
}

extension SlideUpPickerView: Themeable {
    
    func applyTheme() {
        self.clearAllBackgroundColors()
        self.dimView.backgroundColor = .black
        self.contentView.backgroundColor = .red
    }
    
}
