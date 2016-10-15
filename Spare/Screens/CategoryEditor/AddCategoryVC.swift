//
//  AddCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class AddCategoryVC: BaseFormVC {
    
    let editor = CategoryEditorVC(category: nil)
    let queue = OperationQueue()
    
    override var formScrollView: UIScrollView {
        return self.editor.customView.scrollView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "New Category"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.editor)
    }
    
    override func handleTapOnDoneBarButtonItem(_ sender: AnyObject) {
        self.queue.addOperation(
            ValidateCategoryOperation(category: self.editor.category)
            .onSuccess({[unowned self] (_) in
                self.editor.managedObjectContext.saveContext({[unowned self] (result) in
                    switch result {
                    case .failure(let error):
                        MDErrorDialog.showError(error, inPresenter: self)
                        
                    default:
                        MDDispatcher.asyncRunInMainThread({[unowned self] in
                            self.editor.reset()
                        })
                    }
                })
            })
            
            .onFail({[unowned self] (error) in
                MDErrorDialog.showError(error, inPresenter: self)
            })
        )
    }
    
}
