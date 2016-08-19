//
//  __DPVCHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var headerLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let texts = ["S", "M", "T", "W", "T", "F", "S"]
        for i in 0 ..< self.headerLabels.count {
            let label = self.headerLabels[i]
            label.textAlignment = .Center
            label.text = texts[i]
        }
    }
    
}
