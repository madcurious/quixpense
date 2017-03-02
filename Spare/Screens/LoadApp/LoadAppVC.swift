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
    
    override func makeOperations() -> [MDOperation]? {
        let initializeOp = InitializeCoreDataStackOperation()
        initializeOp.successBlock = MDOperationSuccessBlock(runsInMainThread: false, block: { result in
            let persistentContainer = result as! NSPersistentContainer
            let coreDataStack = CoreDataStack(persistentContainer: persistentContainer)
            Global.coreDataStack = coreDataStack
            
            if Debug.shouldGenerateDummyData == false {
                MDDispatcher.asyncRunInMainThread {[unowned self] in
                    self.navigationController?.pushViewController(RootVC(), animated: true)
                }
            }
        })
        
        let generateDummyDataOp = GenerateDummyDataOperation()
        generateDummyDataOp.successBlock = MDOperationSuccessBlock(block: {[unowned self] (result) in
            self.navigationController?.pushViewController(RootVC(), animated: true)
        })
        generateDummyDataOp.addDependency(initializeOp)
        
        if Debug.shouldGenerateDummyData == false {
            generateDummyDataOp.cancel()
        }
        
        return [initializeOp, generateDummyDataOp]
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
    
}
