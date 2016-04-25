//
//  EditCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class EditCategoryVC: BaseVC {
    
    var managedObjectContext: NSManagedObjectContext
    var category: Category
    
    let customView = __ECVCView.instantiateFromNib() as __ECVCView
    
    init(category: Category?) {
        let context = App.state.coreDataStack.newBackgroundWorkerMOC()
        self.managedObjectContext = context
        self.category = category ?? Category(managedObjectContext: context)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
}