//
//  CategoryFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 24/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class CategoryFieldView: ClassifierFieldView {
    
    private let placeholder = "Category"
    
    override func setup() {
        super.setup()
        
        iconImageView.image = UIImage.templateNamed("categoryIcon")
        
        setCategory(.none)
    }
    
    func setCategory(_ category: CategorySelection) {
        switch category {
        case .none:
            nameLabel.text = placeholder
            nameLabel.textColor = Global.theme.color(for: .placeholder)
            clearButton.isHidden = true
            
        case .existing(let objectID):
            if let category = Global.coreDataStack.viewContext.object(with: objectID) as? Category,
                let categoryName = category.name {
                nameLabel.text = categoryName
                nameLabel.textColor = Global.theme.color(for: .regularText)
            } else {
                nameLabel.text = placeholder
                nameLabel.textColor = Global.theme.color(for: .placeholder)
            }
            clearButton.isHidden = false
            
        case .new(let categoryName):
            nameLabel.text = categoryName
            nameLabel.textColor = Global.theme.color(for: .regularText)
            clearButton.isHidden = false
        }
    }
    
}
