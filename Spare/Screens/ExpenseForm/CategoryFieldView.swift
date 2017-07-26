//
//  CategoryFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 24/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class CategoryFieldView: UIView, Themeable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: MDButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var clearButton: MDButton!
    @IBOutlet weak var clearButtonImageView: UIImageView!
    
    private let placeholder = "Category"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearAllBackgroundColors()
        applyTheme()
        
        imageView.image = UIImage.templateNamed("categoryIcon")
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        setCategory(.none)
        
        clearButtonImageView.image = UIImage.templateNamed("cellAccessoryClear")
    }
    
    func applyTheme() {
        imageView.tintColor = Global.theme.color(for: .fieldIcon)
        nameLabel.font = Global.theme.font(for: .regularText)
        clearButtonImageView.tintColor = Global.theme.color(for: .cellAccessoryClear)
    }
    
    func setCategory(_ category: CategoryArgument) {
        switch category {
        case .none:
            nameLabel.text = placeholder
            nameLabel.textColor = Global.theme.color(for: .placeholder)
            
        case .id(let objectID):
            if let category = Global.coreDataStack.viewContext.object(with: objectID) as? Category,
                let categoryName = category.name {
                nameLabel.text = categoryName
                nameLabel.textColor = Global.theme.color(for: .regularText)
            } else {
                nameLabel.text = placeholder
                nameLabel.textColor = Global.theme.color(for: .placeholder)
            }
            
        case .name(let categoryName):
            nameLabel.text = categoryName
            nameLabel.textColor = Global.theme.color(for: .regularText)
        }
    }
    
}
