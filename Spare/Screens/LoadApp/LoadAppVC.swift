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

class LoadAppVC: MDLoadableViewController {
    
    let operationQueue = OperationQueue()
    let customView = _LAVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initializeOperation = InitializeCoreDataStackOperation()
        initializeOperation.successBlock = {[unowned self] persistentContainer in
            let coreDataStack = CoreDataStack(persistentContainer: persistentContainer)
            Global.coreDataStack = coreDataStack
            
            if Debug.shouldGenerateDummyData {
                let makeDummyDataOperation = MakeDummyDataOperation()
                makeDummyDataOperation.successBlock = {[unowned self] _ in
                    self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
                }
                self.operationQueue.addOperation(makeDummyDataOperation)
            } else {
                self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
            }
        }
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
    
    /*
    override func makeOperations() -> [MDOperation]? {
        var operations = [MDOperation]()
        
        let initializeOp = InitializeCoreDataStackOperation()
        initializeOp.successBlock = MDOperationSuccessBlock(runsInMainThread: false, block: { result in
            let persistentContainer = result as! NSPersistentContainer
            let coreDataStack = CoreDataStack(persistentContainer: persistentContainer)
            Global.coreDataStack = coreDataStack
            
            // Generate default data if it hasn't been done before.
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: UserDefaultsKey.hasGeneratedDefaultData.rawValue) == false {
                let makeDefaultDataOp = MakeDefaultDataOperation()
                makeDefaultDataOp.successBlock = MDOperationSuccessBlock(runsInMainThread: false, block: { (_) in
                    userDefaults.set(true, forKey: UserDefaultsKey.hasGeneratedDefaultData.rawValue)
                    userDefaults.synchronize()
                })
                makeDefaultDataOp.addDependency(initializeOp)
                
                // If there is a MakeDummyDataOperation, make it dependent on the MakeDefaultDataOperation.
                if let makeDummyDataOp = self.operationQueue.operations.first(where: { $0 is MakeDummyDataOperation }) {
                    makeDummyDataOp.removeDependency(initializeOp)
                    makeDummyDataOp.addDependency(makeDefaultDataOp)
                }
                
                self.operationQueue.addOperation(makeDefaultDataOp)
            }
            
            if Debug.shouldGenerateDummyData == false {
                MDDispatcher.asyncRunInMainThread {[unowned self] in
                    self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
                }
            }
        })
        operations.append(initializeOp)
        
        if Debug.shouldGenerateDummyData {
            let makeDummyDataOp = MakeDummyDataOperation()
            makeDummyDataOp.successBlock = MDOperationSuccessBlock(block: {[unowned self] (result) in
                self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
            })
            makeDummyDataOp.addDependency(initializeOp)
            operations.append(makeDummyDataOp)
        }
        
        return operations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func updateView(forState state: MDOperationViewController.State) {
        super.updateView(forState: state)
        
        if case .failed(let error) = state {
            MDErrorDialog.showError(error, from: self)
        }
    }
 */
    
}
