//
//  EFPickerSearchVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFPickerSearchVC: UIViewController {
    
    enum TableView {
        case full, results
    }
    
    let customView = _EFPSVCView.instantiateFromNib()
    var currentTableView = TableView.full
    
    override func loadView() {
        self.view = self.customView
    }
    
    func showTableView(_ tableView: TableView) {
        self.currentTableView = tableView
        self.customView.fullTableView.isHidden = tableView != .full
        self.customView.resultsTableView.isHidden = tableView != .results
    }
    
}
