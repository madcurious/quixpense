//
//  LoadAppVC.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class LoadAppVC: MDStatefulViewController {
    
    override func buildOperation() -> MDOperation? {
        let op = LoadAppOperation().onSuccess {[unowned self] (result) in
            guard let stack = result as? CoreDataStack,
                let navController = self.navigationController
                else {
                    return
            }
            
            App.state.coreDataStack = stack
            navController.pushViewController(MainContainerVC(), animated: true)
        }
        return op
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}