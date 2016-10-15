//
//  LoadAppVC.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class LoadAppVC: MDOperationViewController {
    
    override func buildOperation() -> MDOperation? {
        let op = LoadAppOperation().onSuccess {[unowned self] (result) in
            App.coreDataStack = result as! NSPersistentContainer
            
            NotificationCenter.default.post(name: Notifications.LoadAppVCFinishedLoadingCoreDataStack, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        return op
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
