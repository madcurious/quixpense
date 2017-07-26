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
    
    @IBOutlet weak var editButton: MDLabelButton!
    @IBOutlet weak var removeButton: MDImageButton!
    
    private let placeholder = "Category"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyTheme()
        
        imageView.image = UIImage.templateNamed("categoryIcon")
        
        editButton.titleLabel.numberOfLines = 0
        editButton.titleLabel.lineBreakMode = .byWordWrapping
        setCategory(.none)
        
        editButton.backgroundColor = .red
    }
    
    func applyTheme() {
        imageView.tintColor = Global.theme.color(for: .fieldIcon)
        editButton.titleLabel.font = Global.theme.font(for: .regularText)
    }
    
    func setCategory(_ category: CategoryArgument) {
        switch category {
        case .none:
            editButton.titleLabel.text = placeholder
            editButton.titleLabel.textColor = Global.theme.color(for: .placeholder)
            
        case .id(let objectID):
            if let category = Global.coreDataStack.viewContext.object(with: objectID) as? Category,
                let categoryName = category.name {
                editButton.titleLabel.text = categoryName
                editButton.titleLabel.textColor = Global.theme.color(for: .regularText)
            } else {
                editButton.titleLabel.text = placeholder
                editButton.titleLabel.textColor = Global.theme.color(for: .placeholder)
            }
            
        case .name(let categoryName):
            editButton.titleLabel.text = categoryName
            editButton.titleLabel.textColor = Global.theme.color(for: .regularText)
        }
    }
    
}
