//
//  CategoryEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import Mold

class CategoryEditorVC: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var category: Category
    
    let customView = __CEVCView.instantiateFromNib() as __CEVCView
    
    fileprivate let defaultColor = UIColor(hex: 0xff1500)
    
    override var formScrollView: UIScrollView {
        return self.customView.scrollView
    }
    
    init(category: Category?) {
        let context = App.coreDataStack.newChildContext()
        self.managedObjectContext = context
        
        if let objectID = category?.objectID,
            let category = context.object(with: objectID) as? Category {
            self.category = category
        } else {
            self.category = Category(managedObjectContext: context)
            self.category.colorHex = self.defaultColor.hexValue() as NSNumber?
        }
        
        super.init(nibName: nil, bundle: nil)
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
        
        self.customView.colorPickerControl.addTarget(self, action: #selector(handleColorPickerChanged), for: .valueChanged)
        self.customView.colorPickerControl.selectedColor = self.category.color
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    }
    
    func handleTapOnView() {
        self.dismissKeyboard()
    }
    
    func handleColorPickerChanged() {
        let selectedColor = self.customView.colorPickerControl.selectedColor
        self.customView.colorBoxView.backgroundColor = selectedColor
        self.customView.colorTextField.text = "#" + String(selectedColor.hexValue(), radix: 16, uppercase: true)
        
        // Update the model.
        self.category.colorHex = selectedColor.hexValue() as NSNumber?
    }
    
    /**
     Clears the form and creates a new `Category` object with form-initial values.
     */
    func reset() {
        self.customView.nameTextField.text = nil
        self.category = Category(managedObjectContext: self.managedObjectContext)
        self.category.name = nil
        self.category.colorHex = self.customView.colorPickerControl.selectedColor.hexValue() as NSNumber?
    }
    
}

extension CategoryEditorVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let name = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        self.category.name = name
        return true
    }
    
}

