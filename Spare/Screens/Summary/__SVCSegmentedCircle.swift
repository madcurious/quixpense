//
//  __SVCSegmentedCircle.swift
//  Spare
//
//  Created by Matt Quiros on 10/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCSegmentedCircle: UIView {
    
    var summary: Summary? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
}