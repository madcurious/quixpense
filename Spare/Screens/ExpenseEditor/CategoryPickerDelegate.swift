//
//  CategoryPickerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CategoryPickerDelegate: CustomPickerDelegate {

    var categories: [Category]
    
    override var dataSource: [Any] {
        var categories = self.categories.map({ $0 as Any })
        categories.append("Or, add a new category...")
        return categories
    }
    
    var categorySelectionAction: ((Int) -> ())?
    var addCategoryAction: (() -> ())?
    
    override var tapAction: ((Int) -> ())? {
        get {
            return {[unowned self] index in
                if index == self.dataSource.count - 1 {
                    self.addCategoryAction?()
                } else {
                    self.categorySelectionAction?(index)
                }
            }
        }
        set {
            fatalError("Can't set tapAction for \(self.classForCoder.description())")
        }
    }
    
    init(categories: [Category], selectedIndex: Int) {
        self.categories = categories
        super.init(selectedIndex: selectedIndex)
    }
    
    override func text(forIndexPath indexPath: IndexPath) -> String? {
        guard indexPath.row < self.dataSource.count - 1
            else {
                return nil
        }
        return self.categories[indexPath.row].name
    }
    
    override func attributedString(forIndexPath indexPath: IndexPath) -> NSAttributedString? {
        guard indexPath.row == self.dataSource.count - 1
            else {
                return nil
        }
        
        return NSAttributedString(string: "Or, add a new category...", font: Font.CustomPickerText, textColor: Color.CustomPickerHeaderTextColor)
    }
    
}
