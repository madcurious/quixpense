//
//  __MCVCView.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __MCVCView: UIView {
    
    @IBOutlet weak var tabContainer: UIView!
    @IBOutlet weak var tabBarContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.tabContainer, self.tabBarContainer)
        self.backgroundColor = Color.HomeScreenBackgroundColor
    }
    
}