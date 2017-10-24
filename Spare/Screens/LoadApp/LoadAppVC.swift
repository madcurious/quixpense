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
        
        let loadOp = LoadCoreDataStackOperation(inMemory: false) {[weak self] (result) in
            guard let weakSelf = self,
                let result = result
                else {
                    return
            }
            switch result {
            case .error(let error):
                BRAlertDialog.showInPresenter(weakSelf, title: nil, message: error.localizedDescription, cancelButtonTitle: "OK")
                
            case .success(let container):
                Global.coreDataStack = container
                
                // Needs to be inside the completion block because the Global.coreDataStack variable needs to have been set.
                // If loadOp is added as a dependency instead, makeDummyDataOp will be triggered once loadOp finishes,
                // but without waiting for loadOp.completionBlock to finish, during which Global.coreDataStack is not yet set.
                let makeDummyDataOp = MakeDummyDataOperation(from: .lastDateSpent) { [weak self] (result) in
                    guard let weakSelf = self,
                        let result = result
                        else {
                            return
                    }
                    switch result {
                    case .error(let error):
                        BRAlertDialog.showInPresenter(weakSelf, title: nil, message: error.localizedDescription, cancelButtonTitle: "OK")
                    default:
                        DispatchQueue.main.async {
                            weakSelf.navigationController?.pushViewController(MainTabBarVC(), animated: true)
                        }
                    }
                }
                weakSelf.operationQueue.addOperation(makeDummyDataOp)
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
