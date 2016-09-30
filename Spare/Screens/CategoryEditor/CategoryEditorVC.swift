//
//  CategoryEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

class CategoryEditorVC: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var category: Category
    
    let customView = __CEVCView.instantiateFromNib() as __CEVCView
    
    private let defaultColor = UIColor.redColor()
    
    override var formScrollView: UIScrollView {
        return self.customView.scrollView
    }
    
    init(category: Category?) {
        let context = App.coreDataStack.newBackgroundWorkerMOC()
        self.managedObjectContext = context
        
        if let objectID = category?.objectID,
            let category = context.objectWithID(objectID) as? Category,
            let colorHex = category.colorHex as? Int {
            self.category = category
            self.customView.colorPickerControl.selectedColor = UIColor(hex: colorHex)
        } else {
            self.category = Category(managedObjectContext: context)
            self.category.colorHex = self.defaultColor.hexValue()
            self.customView.colorPickerControl.selectedColor = self.defaultColor
        }
        
        super.init(nibName: nil, bundle: nil)
        
        self.customView.colorBoxView.backgroundColor = self.customView.colorPickerControl.selectedColor
        
        let request = NSFetchRequest(entityName: Category.entityName)
        if let categories = try! self.managedObjectContext.executeFetchRequest(request) as? [Category] {
            print(categories)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.customView.nameTextField.delegate = self
        self.customView.nameTextField.text = self.category.name
        
        self.customView.colorPickerControl.addTarget(self, action: #selector(handleColorPickerChanged), forControlEvents: .ValueChanged)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    }
    
    func handleTapOnView() {
        self.dismissKeyboard()
    }
    
    func handleColorPickerChanged() {
        self.customView.colorBoxView.backgroundColor = self.customView.colorPickerControl.selectedColor
    }
    
    /**
     Clears the form and creates a new `Category` object with form-initial values.
     */
    func reset() {
        self.customView.nameTextField.text = nil
        self.category = Category(managedObjectContext: self.managedObjectContext)
        self.category.name = nil
        self.category.colorHex = self.customView.colorPickerControl.selectedColor.hexValue()
    }
    
}

extension CategoryEditorVC: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let name = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        self.category.name = name
        return true
    }
    
}

