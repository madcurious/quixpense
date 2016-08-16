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
        return self.categories.map({ $0 as Any })
    }
    
    init(categories: [Category], selectedIndex: Int) {
        self.categories = categories
        super.init(selectedIndex: selectedIndex)
    }
    
    override func textForItemAtIndexPath(indexPath: NSIndexPath) -> String? {
        return self.categories[indexPath.row].name
    }
    
}
