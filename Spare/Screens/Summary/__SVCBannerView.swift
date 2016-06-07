//
//  __SVCBannerView.swift
//  Spare
//
//  Created by Matt Quiros on 06/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCBannerView: UICollectionReusableView {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.labelContainer)
    }
    
}
