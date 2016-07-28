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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.barTintColor = Color.UniversalBackgroundColor
        self.navigationBar.tintColor = Color.UniversalTextColor
        self.navigationBar.translucent = false
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.borderView.frame = CGRectMake(0, self.navigationBar.bounds.size.height - 0.5, self.navigationBar.bounds.size.width, 0.5)
    }
    
}
