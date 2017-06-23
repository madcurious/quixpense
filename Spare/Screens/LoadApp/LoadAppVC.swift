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

class LoadAppVC: UIViewController {
    
    var operationQueue = OperationQueue()
    let customView = _LAVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initializeOperation = InitializeCoreDataStackOperation(inMemory: false)
        initializeOperation.successBlock = { result in
            let coreDataStack = CoreDataStack(persistentContainer: result)
            Global.coreDataStack = coreDataStack
            
            let makeDummyDataOperation = MakeDummyDataOperation()
            makeDummyDataOperation.successBlock = {[unowned self] _ in
                self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
            }
            makeDummyDataOperation.presentErrorDialogOnFailure(from: self)
            self.operationQueue.addOperation(makeDummyDataOperation)
        }
        initializeOperation.presentErrorDialogOnFailure(from: self)
        
        self.operationQueue.addOperation(initializeOperation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customView.activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.customView.activityIndicator.stopAnimating()
    }
    
}
