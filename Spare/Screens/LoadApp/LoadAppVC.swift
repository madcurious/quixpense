//
//  LoadAppVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class LoadAppVC: MDOperationViewController {
    
    let customView = _LAVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeOperation() -> MDOperation? {
        return InitializeCoreDataStackOperation()
        .onSuccess({ (result) in
            guard let persistentContainer = result as? NSPersistentContainer
                else {
                    return
            }
            
            let coreDataStack = CoreDataStack(persistentContainer: persistentContainer)
            Global.coreDataStack = coreDataStack
            
            self.navigationController?.pushViewController(RootVC(), animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
