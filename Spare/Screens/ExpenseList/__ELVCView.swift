//
//  __ELVCView.swift
//  Spare
//
//  Created by Matt Quiros on 22/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCView: UIView {
    
    /**
     This view is a fake extension of the collection view's header so that the header's background
     color is continuous when the user scrolls to negative y offset.
     */
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerBackgroundViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.ExpenseListScreenBackgroundColor
        self.collectionView.backgroundColor = UIColor.clearColor()
    }
    
}
