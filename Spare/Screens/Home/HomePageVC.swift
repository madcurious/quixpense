//
//  HomePageVC.swift
//  Spare
//
//  Created by Matt Quiros on 24/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class HomePageVC: MDOperationViewController {
    
    let customLoadingView = OperationVCLoadingView()
    
    override var loadingView: UIView {
        return self.customLoadingView
    }
    
    var dateRange: DateRange
    
    init(dateRange: DateRange) {
        self.dateRange = dateRange
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

