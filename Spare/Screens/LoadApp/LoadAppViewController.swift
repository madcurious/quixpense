//
//  LoadAppViewController.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock
import CoreData

class LoadAppViewController: UIViewController {
    
    var operationQueue = OperationQueue()
    let loadableView = BRDefaultLoadableView(frame: .zero)
    
    override func loadView() {
        view = loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadableView.retryButton.addTarget(self, action: #selector(loadPersistentContainer), for: .touchUpInside)
        
        loadPersistentContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func loadPersistentContainer() {
        let loadOp = BRLoadPersistentContainer(documentName: "Spare", inMemory: false) { [weak self] (result) in
            guard let weakSelf = self,
                let result = result
                else {
                    return
            }
            switch result {
            case .error(let error):
                weakSelf.loadableView.state = .error(error)
                
            case .success(let persistentContainer):
                Global.coreDataStack = persistentContainer
            }
        }
        
        let makeDummyDataOp = MakeDummyDataOperation(from: .lastDateSpent) { [weak self] (result) in
            guard let weakSelf = self,
                let result = result
                else {
                    return
            }
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    weakSelf.loadableView.state = .error(error)
                    
                default: ()
//                    weakSelf.navigationController?.pushViewController(MainTabBarVC(), animated: true)
                }
            }
        }
        makeDummyDataOp.addDependency(loadOp)
        
        loadableView.state = .loading
        operationQueue.addOperations([loadOp, makeDummyDataOp], waitUntilFinished: false)
    }
    
}
