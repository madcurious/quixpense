//
//  GlobalFunctions.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import Mold

func glb_applyGlobalVCSettings(viewController: UIViewController) {
    viewController.edgesForExtendedLayout = .None
    
    if let navigationBar = viewController.navigationController?.navigationBar {
        let backLabel = UILabel()
        backLabel.text = Icon.Back.rawValue
        backLabel.font = Font.icon(20)
        backLabel.opaque = false
        backLabel.sizeToFit()
        if let backImage = UIImage.imageFromView(backLabel) {
            navigationBar.backIndicatorImage = backImage
            navigationBar.backIndicatorTransitionMaskImage = backImage
        }
    }
    viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    let titleLabel = UILabel()
    titleLabel.textColor = Color.UniversalTextColor
    titleLabel.font = Font.NavBarTitle
    titleLabel.text = viewController.title
    titleLabel.sizeToFit()
    viewController.navigationItem.titleView = titleLabel
}

/**
 A wrapper for any closure that may throw an exception for unexpected reasons. When an exception is thrown,
 an error is automatically reported to the bug tracking tool.
 */

func glb_autoreport(closure: () throws -> ()) {
    do {
        try closure()
    } catch {
        fatalError("Found error but no auto-reporting logic yet. Error: \(error as NSError)")
    }
}

func glb_autoreport<T>(closure: Void throws -> T?) -> T? {
    do {
        return try closure()
    } catch {
        // Report here.
        fatalError("Found error but no auto-reporting logic yet. Error: \(error as NSError)")
    }
}

func glb_autoreport<T>(closure: Void throws -> T, defaultValue: T) -> T {
    do {
        return try closure()
    } catch {
        // Report here.
        return defaultValue
    }
}

func glb_totalOfExpenses(expenses: [Expense]) -> NSDecimalNumber {
    return expenses.map({ $0.amount ?? 0}).reduce(0, combine: +)
}
