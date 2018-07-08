//
//  SetupViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 21/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock
import CoreData

class SetupViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var hasBeenInitialized = false
    
    let queue = OperationQueue()
    
    var successBlock: ((NSPersistentContainer) -> Void)?
    
    init(successBlock: ((NSPersistentContainer) -> Void)?) {
        self.successBlock = successBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = viewFromOwnedNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard hasBeenInitialized == false
            else {
                return
        }
        
        queue.addOperation(SetupApp(
            updateBlock: { [weak self] message in
                DispatchQueue.main.async {
                    self?.statusLabel.text = message
                }
            },
            completionBlock: { [weak self] result in
                guard let result = result,
                    case .success(let container) = result,
                    let successBlock = self?.successBlock
                    else {
                        return
                }
                successBlock(container)
        }))
        
        hasBeenInitialized = true
    }
    
}
