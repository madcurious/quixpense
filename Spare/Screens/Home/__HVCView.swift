//
//  __HVCView.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
}
