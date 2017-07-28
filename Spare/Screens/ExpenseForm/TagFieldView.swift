//
//  TagFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 24/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class TagFieldView: ClassifierFieldView {
    
    private let placeholder = "Tags"
    
    override func setup() {
        super.setup()
        
        iconImageView.image = UIImage.templateNamed("tagIcon")
        
        setTags(.none)
    }
    
    func setTags(_ tags: TagSelection) {
        switch tags {
        case .set(let set) where set.isEmpty == false:
            let tagNames = set.flatMap {
                switch $0 {
                case .id(let objectID):
                    if let tag = Global.coreDataStack.viewContext.object(with: objectID) as? Tag,
                        let tagName = tag.name {
                        return tagName
                    }
                    return nil
                case .name(let tagName):
                    return tagName
                }
            }
            nameLabel.text = tagNames.joined(separator: ", ")
            nameLabel.textColor = Global.theme.color(for: .regularText)
            clearButton.isHidden = false
            
            
        default:
            nameLabel.text = placeholder
            nameLabel.textColor = Global.theme.color(for: .placeholder)
            clearButton.isHidden = true
        }
    }
    
}
