//
//  EditCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 26/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class EditCategoryVC: BaseFormVC {
    
    var editor: CategoryEditorVC
    
    override var formScrollView: UIScrollView {
        return self.editor.customView.scrollView
    }
    
    init(category: Category) {
        self.editor = CategoryEditorVC(category: category)
        super.init(nibName: nil, bundle: nil)
        
        self.title = "EDIT CATEGORY"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.editor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}