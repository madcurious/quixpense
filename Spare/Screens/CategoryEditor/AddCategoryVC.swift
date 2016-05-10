//
//  AddCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 09/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class AddCategoryVC: BaseFormVC {
    
    let editor = CategoryEditorVC(category: nil)
    
    override init() {
        super.init()
        self.title = "NEW CATEGORY"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.editor)
    }
    
    
    
}