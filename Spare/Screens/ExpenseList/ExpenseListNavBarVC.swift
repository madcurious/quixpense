//
//  ExpenseListNavBarVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListNavBarVC: BaseNavBarVC {
    
    let editingNavigationBar = UINavigationBar(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editingNavigationBar.isTranslucent = false
        self.editingNavigationBar.barTintColor = UIColor.red
        self.editingNavigationBar.alpha = 0
        
        self.view.addSubview(self.editingNavigationBar)
        self.view.backgroundColor = Global.theme.color(for: .mainBackground)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let editingNavigationBarY = UIApplication.shared.statusBarFrame.size.height > 20 ? self.navigationBar.frame.origin.y : 0
        let statusBarHeightOffset = UIApplication.shared.statusBarFrame.size.height > 20 ? 0 : UIApplication.shared.statusBarFrame.size.height
        
        self.editingNavigationBar.frame = CGRect(x: 0,
                                                 y: editingNavigationBarY,
                                                 width: self.navigationBar.frame.size.width,
                                                 height: self.navigationBar.frame.size.height + statusBarHeightOffset)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0,
                                options: [.layoutSubviews],
                                animations: {[unowned self] in
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        self.navigationBar.alpha = editing ? 0 : 1
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        self.editingNavigationBar.alpha = editing ? 1 : 0
                                    })
        })
    }
    
}
