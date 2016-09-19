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
    
    @IBOutlet var separatorView: UIView!
    @IBOutlet var buttonContainers: [UIView]!
    
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    
    let homeButton = TabButton(.Home)
    let addButton = AddButton()
    let settingsButton = TabButton(.Settings)
    
    var selectedIndex = 0
    var delegate: MainTabBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.multipleTouchEnabled = false
        
        self.backgroundColor = Color.TabBarBackgroundColor
        self.separatorView.backgroundColor = Color.SeparatorColor
        UIView.clearBackgroundColors(self.buttonContainers)
        
        self.separatorViewHeight.constant = 0.5
        
        // Setup all the buttons.
        let buttons = [self.homeButton, self.addButton, self.settingsButton]
        for i in 0..<buttons.count {
            let container = self.buttonContainers[i]
            let button = buttons[i]
            
            container.addSubviewAndFill(button)
            
            if let tabButton = button as? TabButton {
                tabButton.delegate = self
            }
        }
        
        // Select the home button by default.
        self.homeButton.selected = true
    }
    
}

extension MainTabBar: TabButtonDelegate {
    
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
