//
//  FormNavigationController.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class FormNavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
}
