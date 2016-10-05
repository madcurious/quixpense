//
//  EditCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 26/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class EditCategoryVC: BaseFormVC {
    
    var editor: CategoryEditorVC
    let queue = OperationQueue()
    
    override var formScrollView: UIScrollView {
        return self.editor.customView.scrollView
    }
    
    init(category: Category) {
        self.editor = CategoryEditorVC(category: category)
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Edit Category"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.editor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleTapOnDoneBarButtonItem(_ sender: AnyObject) {
        self.queue.addOperation(
            ValidateCategoryOperation(category: self.editor.category)
                .onSuccess({[unowned self] (_) in
                    self.editor.managedObjectContext.saveContext({[unowned self] (result) in
                        switch result {
                        case .Failure(let error as NSError):
                            MDErrorDialog.showError(error, inPresenter: self)
                            
                        default:
                            MDDispatcher.asyncRunInMainThread({[unowned self] in
                                self.dismiss(animated: true, completion: nil)
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
