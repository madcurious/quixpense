//
//  BaseNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class BaseNavBarVC: UINavigationController {
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.SeparatorColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addSubview(self.borderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.barTintColor = Color.NavigationBarBackgroundColor
        self.navigationBar.tintColor = Color.UniversalTextColor
        self.navigationBar.isTranslucent = false
        
        let borderHeight = CGFloat(0.5)
        self.borderView.frame = CGRect(x: 0, y: self.navigationBar.bounds.size.height - borderHeight, width: self.navigationBar.bounds.size.width, height: borderHeight)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}
