//
//  FilterPopupViewController.swift
//  Spare
//
//  Created by Matt Quiros on 30/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class FilterPopupViewController: UIViewController {
    
    let customView = FilterPopupView.instantiateFromNib()
    
    var filter: Filter
    
    init(filter: Filter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.periodizationControl.selectedSegmentIndex = self.filter.periodization.rawValue
        self.customView.periodizationControl.addTarget(self, action: #selector(handleValueChangeOnPeriodization), for: .valueChanged)
        
        self.customView.groupingControl.selectedSegmentIndex = self.filter.grouping.rawValue
        self.customView.groupingControl.addTarget(self, action: #selector(handleValueChangeOnGrouping), for: .valueChanged)
    }
    
    @objc func handleValueChangeOnPeriodization(sender: UISegmentedControl) {
        self.filter.periodization = Periodization(rawValue: sender.selectedSegmentIndex)!
    }
    
    @objc func handleValueChangeOnGrouping(sender: UISegmentedControl) {
        self.filter.grouping = Grouping(rawValue: sender.selectedSegmentIndex)!
    }
    
}
