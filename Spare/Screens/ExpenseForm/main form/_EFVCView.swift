//
//  _EFVCView.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let amountBox = _EFVCAmountBox.instantiateFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.alwaysBounceVertical = true
        
        self.stackView.addArrangedSubview(self.amountBox)
        
    }
    
}
