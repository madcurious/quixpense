//
//  BarButtonItems.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

final class BarButtonItems {
    
    enum ButtonType {
        case back
        case cancel
        case done
    }
    
    class func make(_ buttonType: ButtonType, target: Any, action: Selector) -> UIBarButtonItem {
        let button: MDImageButton = {
            switch buttonType {
            case .back:
                return self.makeBackButton()
                
            case .cancel:
                return self.makeCancelButton()
                
            case .done:
                return self.makeDoneButton()
            }
        }()
        
        button.addTarget(target, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    fileprivate class func makeBackButton() -> MDImageButton {
        let backButton = MDImageButton()
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.image = UIImage.templateNamed("navBarButtonBack")
        return backButton
    }
    
    fileprivate class func makeCancelButton() -> MDImageButton {
        let cancelButton = MDImageButton()
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.image = UIImage.templateNamed("navBarButtonCancel")
        return cancelButton
    }
    
    fileprivate class func makeDoneButton() -> MDImageButton {
        let doneButton = MDImageButton()
        doneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.image = UIImage.templateNamed("navBarButtonDone")
        return doneButton
    }
    
}
