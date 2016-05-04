//
//  MainTabBar.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

protocol MainTabBarDelegate {
    
    func mainTabBarDidSelectIndex(index: Int)
    
}

class MainTabBar: UIView {
    
    @IBOutlet var buttonContainers: [UIView]!
    
    let homeButton = TabButton(.Home)
    let addButton = TabButton(.Add)
    let settingsButton = TabButton(.Settings)
    
    var buttons: [TabButton] {
        return [self.homeButton, self.addButton, self.settingsButton]
    }
    
    var selectedIndex = 0
    var delegate: MainTabBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.multipleTouchEnabled = false
        
        self.backgroundColor = Color.White
        UIView.clearBackgroundColors(self.buttonContainers)
        
        // Setup all the buttons.
        for i in 0..<self.buttons.count {
            let container = self.buttonContainers[i]
            let button = self.buttons[i]
            
            container.addSubviewAndFill(button)
            button.delegate = self
        }
        
        // Select the home button by default.
        self.homeButton.selected = true
    }
    
}

extension MainTabBar: TabButtonDelegate {
    
    func tabButtonShouldBeSelected(tabButton: TabButton) -> Bool {
        if tabButton == self.addButton {
            return false
        }
        return true
    }
    
    func tabButtonDidSelect(tabButton: TabButton) {
        switch tabButton {
        case self.homeButton:
            self.settingsButton.selected = false
            self.selectedIndex = 0
            
        case self.settingsButton:
            self.homeButton.selected = false
            self.selectedIndex = 1
            
        default:
            return
        }
        
        if let delegate = self.delegate {
            // This code won't be executed if it's not the home or settings button.
            delegate.mainTabBarDidSelectIndex(self.selectedIndex)
        }
    }
    
}
