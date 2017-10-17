//
//  BarButtonItems.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

final class BarButtonItems {
    
    enum ButtonType {
        case back
        case cancel
        case done
    }
    
    class func make(_ buttonType: ButtonType, target: Any, action: Selector) -> UIBarButtonItem {
        let button: BRImageButton = {
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
    
    private class func makeBackButton() -> BRImageButton {
        let backButton = BRImageButton()
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.image = UIImage.template(named: "navBarButtonBack")
        return backButton
    }
    
    private class func makeCancelButton() -> BRImageButton {
        let cancelButton = BRImageButton()
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.image = UIImage.template(named: "navBarButtonCancel")
        return cancelButton
    }
    
    private class func makeDoneButton() -> BRImageButton {
        let doneButton = BRImageButton()
        doneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.image = UIImage.template(named: "navBarButtonDone")
        return doneButton
    }
    
}
