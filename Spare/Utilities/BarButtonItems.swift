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
        case cancel
        case done
    }
    
    class func make(_ buttonType: ButtonType, target: Any, action: Selector) -> UIBarButtonItem {
        let button: MDImageButton = {
            switch buttonType {
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
    
    fileprivate class func makeCancelButton() -> MDImageButton {
        let cancelButton = MDImageButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cancelButton.image = UIImage.templateNamed("navBarButtonCancel")
        return cancelButton
    }
    
    fileprivate class func makeDoneButton() -> MDImageButton {
        let doneButton = MDImageButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.image = UIImage.templateNamed("navBarButtonDone")
        return doneButton
    }
    
}
