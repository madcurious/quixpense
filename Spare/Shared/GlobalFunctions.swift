//
//  GlobalFunctions.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack

func glb_applyGlobalVCSettings(viewController: UIViewController) {
    viewController.edgesForExtendedLayout = .None
}

/**
 Returns all the categories in the store, or nil if the fetch returned an empty array or threw an exception.
 */
func glb_allCategories() -> [Category]? {
    return glb_protect {
        let request = NSFetchRequest(entityName: Category.entityName)
        if let categories = try App.state.mainQueueContext.executeFetchRequest(request) as? [Category]
            where categories.isEmpty == false {
            return categories
        }
        return nil
    }
}

/**
 A wrapper for any closure that may throw an exception for unexpected reasons. When an exception is thrown,
 an error is automatically reported to the bug tracking tool.
 */
func glb_protect<T>(closure: Void throws -> T?) -> T? {
    do {
        return try closure()
    } catch {
        // Report here.
        return nil
    }
}

func glb_textForTotal(total: NSDecimalNumber) -> String {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter.stringFromNumber(total) ?? "$ 0.00"
}
