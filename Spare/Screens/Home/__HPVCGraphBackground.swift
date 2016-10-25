//
//  __HPVCGraphBackground.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HPVCGraphBackground: UIView {
    
    @IBOutlet var edges: [UIView]!
    @IBOutlet var midlines: [UIView]!
    @IBOutlet var heights: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        for edge in self.edges {
            edge.backgroundColor = UIColor.white
        }
        
        for midline in self.midlines {
            midline.backgroundColor = UIColor(hex: 0x555555)
        }
        
        for height in self.heights {
            height.constant = 0.5
        }
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }
    
}

