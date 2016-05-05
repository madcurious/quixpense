//
//  NewCategoryProgressView.swift
//  Spare
//
//  Created by Matt Quiros on 05/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class NewCategoryProgressView: UIView {
    
    let backgroundView = UIView()
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.backgroundView.backgroundColor = Color.Black
        self.backgroundView.alpha = 0.5
        self.addSubviewAndFill(self.backgroundView)
        
        self.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
