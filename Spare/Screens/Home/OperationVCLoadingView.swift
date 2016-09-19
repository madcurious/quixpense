//
//  OperationVCLoadingView.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class OperationVCLoadingView: UIView {
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = Color.UniversalBackgroundColor
    }
    
}
