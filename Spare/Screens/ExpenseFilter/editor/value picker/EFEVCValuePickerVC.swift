//
//  EFEVCValuePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 04/04/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFEVCValuePickerVC: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    public enum ViewID: String {
        case valueCell = "valueCell"
    }
    
    override func loadView() {
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ValuePickerCell.nib(), forCellReuseIdentifier: ViewID.valueCell.rawValue)
    }
    
}
