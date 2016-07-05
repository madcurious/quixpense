//
//  SettingsVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        self.view.backgroundColor = Color.ScreenBackgroundColorLightGray
    }
    
}