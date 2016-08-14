//
//  CustomPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerVC: UIViewController {
    
    let customView = __CPVCView.instantiateFromNib() as __CPVCView
    
    var dataSource: UITableViewDataSource? {
        didSet {
            self.customView.tableView.dataSource = self.dataSource
        }
    }
    
    var delegate: UITableViewDelegate? {
        didSet {
            self.customView.tableView.delegate = self.delegate
        }
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
    }
    
    func handleTapOnDimView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
