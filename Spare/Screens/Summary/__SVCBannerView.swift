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
    @IBOutlet weak var totalLabel: MDAspectFitLabel!
    @IBOutlet weak var dateLabel: MDAspectFitLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.labelContainer, self.totalLabel, self.dateLabel)
        
        self.totalLabel.font = Font.text(.Regular, 30)
        self.totalLabel.textAlignment = .Center
        
        self.dateLabel.font = Font.text(.Regular, 15)
        self.dateLabel.textAlignment = .Center
    }
    
}
