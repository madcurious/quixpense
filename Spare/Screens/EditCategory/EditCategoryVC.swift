//
//  EditCategoryVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Color_Picker_for_iOS

class EditCategoryVC: BaseVC {
    
    var managedObjectContext: NSManagedObjectContext
    var category: Category
    
    let customView = __ECVCView.instantiateFromNib() as __ECVCView
    let colorMap: HRColorMapView
    
    init(category: Category?) {
        let context = App.state.coreDataStack.newBackgroundWorkerMOC()
        self.managedObjectContext = context
        
        
        if let category = category,
            let colorHex = category.color as? Int {
            self.category = category
            self.colorMap = HRColorMapView.defaultColorMap(UIColor(hex: colorHex))
        } else {
            self.category = Category(managedObjectContext: context)
            self.colorMap = HRColorMapView.defaultColorMap(nil)
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
        self.customView.colorMapContainer.addSubviewAndFill(self.colorMap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorMap.addTarget(self, action: #selector(handleTapOnColorMap(_:)), forControlEvents: .ValueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    }
    
    func handleTapOnView() {
        self.dismissKeyboard()
    }
    
    func handleTapOnColorMap(sender: AnyObject) {
        // When the color map is tapped, a color has been selected and the cursor
        // should be displayed.
        self.colorMap.cursor.hidden = false
    }
    
}