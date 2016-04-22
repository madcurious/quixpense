//
//  BaseVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
    }
    
}
