//
//  __DPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var arrowContainer: UIView!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet var headerLabels: [UILabel]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self,
            self.arrowContainer,
            self.headerContainer,
            self.collectionView
        )
        
        let texts = ["S", "M", "T", "W", "T", "F", "S"]
        for i in 0 ..< self.headerLabels.count {
            let label = self.headerLabels[i]
            label.textAlignment = .Center
            label.text = texts[i]
        }
        
        self.collectionView.pagingEnabled = true
    }
    
}
