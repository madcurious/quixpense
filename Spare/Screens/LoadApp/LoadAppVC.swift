//
//  LoadAppVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock
import CoreData

class LoadAppVC: UIViewController {
    
    var operationQueue = OperationQueue()
    let customView = _LAVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadOp = LoadCoreDataStackOperation(inMemory: false) {[unowned self] (result) in
            switch result {
            case .error(let error):
                BRAlertDialog.showInPresenter(self, title: nil, message: error.localizedDescription, cancelButtonTitle: "OK")
                
            case .success(let container):
                Global.coreDataStack = container
                
                // Needs to be inside the completion block because the Global.coreDataStack variable needs to have been set.
                // If loadOp is added as a dependency instead, makeDummyDataOp will be triggered once loadOp finishes,
                // but without waiting for loadOp.completionBlock to finish, during which Global.coreDataStack is not yet set.
                let makeDummyDataOp = MakeDummyDataOperation(from: .lastDateSpent) {[unowned self] (result) in
                    switch result {
                    case .error(let error):
                        BRAlertDialog.showInPresenter(self, title: nil, message: error.localizedDescription, cancelButtonTitle: "OK")
                    default:
                        BRDispatch.asyncRunInMain {
                            self.navigationController?.pushViewController(MainTabBarVC(), animated: true)
                        }
                    }
                }
                self.operationQueue.addOperation(makeDummyDataOp)
                
            default: break
            }
        }
        self.operationQueue.addOperation(loadOp)
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
