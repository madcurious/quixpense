//
//  MainTabBar.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class MainTabBar: UIView {
    
    @IBOutlet var buttonContainers: [UIView]!
    
    let homeButton = TabButton(.Home)
    let addButton = TabButton(.Add)
    let settingsButton = TabButton(.Settings)
    
    var buttons: [TabButton] {
        return [self.homeButton, self.addButton, self.settingsButton]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.White
        UIView.clearBackgroundColors(self.buttonContainers)
        
        for i in 0..<self.buttons.count {
            let container = self.buttonContainers[i]
            let button = self.buttons[i]
            container.addSubviewAndFill(button)
        }
    }
    
}
