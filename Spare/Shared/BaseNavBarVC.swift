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
    
    var statusBarStyle: UIStatusBarStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addSubview(self.borderView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.barTintColor = Color.BarBackgroundColor
        self.navigationBar.tintColor = Color.UniversalTextColor
        self.navigationBar.translucent = false
        
        let borderHeight = CGFloat(0.5)
        self.borderView.frame = CGRectMake(0, self.navigationBar.bounds.size.height - borderHeight, self.navigationBar.bounds.size.width, borderHeight)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let statusBarStyle = self.statusBarStyle {
            return statusBarStyle
        }
        return .Default
    }
    
}
