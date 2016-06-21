//
//  CollectionViewLabel.swift
//  Spare
//
//  Created by Matt Quiros on 16/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class CollectionViewLabel: UICollectionReusableView {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.label)
        
        self.label.textAlignment = .Center
    }
    
}