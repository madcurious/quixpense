//
//  FilterPopupViewController.swift
//  Spare
//
//  Created by Matt Quiros on 30/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

protocol FilterPopupViewControllerDelegate {
    
    func filterPopupViewController(_ viewController: FilterPopupViewController, didSelect filter: Filter)
    
}

class FilterPopupViewController: UIViewController {
    
    let customView = FilterPopupView.instantiateFromNib()
    
    var filter: Filter
    var delegate: FilterPopupViewControllerDelegate
    
    init(filter: Filter, delegate: FilterPopupViewControllerDelegate) {
        self.filter = filter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "FILTER"
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
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
    }
    
    func handleValueChangeOnPeriodization(sender: UISegmentedControl) {
        self.filter.periodization = Filter.Periodization(rawValue: sender.selectedSegmentIndex)!
    }
    
    func handleValueChangeOnGrouping(sender: UISegmentedControl) {
        self.filter.grouping = Filter.Grouping(rawValue: sender.selectedSegmentIndex)!
    }
    
    func handleTapOnCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        self.delegate.filterPopupViewController(self, didSelect: self.filter)
        self.dismiss(animated: true, completion: nil)
    }
}
