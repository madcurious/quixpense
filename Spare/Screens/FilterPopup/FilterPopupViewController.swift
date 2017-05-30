//
//  FilterPopupViewController.swift
//  Spare
//
//  Created by Matt Quiros on 30/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class FilterPopupViewController: UIViewController {
    
    class func present(from parent: UIViewController) {
        let container = BaseNavBarVC(rootViewController: FilterPopupViewController())
        container.modalPresentationStyle = .popover
        
        parent.present(container, animated: true) { 
            guard let popoverController = container.popoverPresentationController,
                let titleView = parent.navigationItem.titleView
                else {
                    return
            }
            popoverController.permittedArrowDirections = [.up]
            popoverController.sourceView = titleView
            popoverController.sourceRect = titleView.frame
        }
    }
    
    let customView = FilterPopupView.instantiateFromNib()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "FILTER"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
    }
    
    func handleTapOnCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
