//
//  EFTBPVCSearchVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class EFTBPVCSearchVC: MDOperationViewController {
    
    let customView = _EFTBPVCSVCView.instantiateFromNib()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func makeOperation() -> MDOperation? {
        return nil
    }
    
}
