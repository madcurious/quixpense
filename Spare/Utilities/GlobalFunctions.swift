//
//  GlobalFunctions.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

func glb_applyGlobalVCSettings(_ viewController: UIViewController) {
    viewController.edgesForExtendedLayout = UIRectEdge()
    
    if let navigationBar = viewController.navigationController?.navigationBar {
        let backLabel = UILabel()
        backLabel.text = Icon.Back.rawValue
        backLabel.font = Font.icon(20)
        backLabel.isOpaque = false
        backLabel.sizeToFit()
        if let backImage = UIImage.imageFromView(backLabel) {
            navigationBar.backIndicatorImage = backImage
            navigationBar.backIndicatorTransitionMaskImage = backImage
        }
    }
    viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    let titleLabel = UILabel()
    titleLabel.textColor = Color.UniversalTextColor
    titleLabel.font = Font.NavBarTitle
    titleLabel.text = viewController.title
    titleLabel.sizeToFit()
    viewController.navigationItem.titleView = titleLabel
}

//func glb_totalOfExpenses(_ expenses: [Expense]) -> NSDecimalNumber {
//    return expenses.map({ $0.amount ?? 0}).reduce(0, +)
//}
