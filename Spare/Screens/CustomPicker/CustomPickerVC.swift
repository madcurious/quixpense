//
//  CustomPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

protocol CustomPickerVCDelegate {
    
    func dataSource(forIdentifier identifier: String) -> [Any]
    func text(forIndexPath indexPath: IndexPath) -> String
    func customPicker(_ customPicker: CustomPickerVC, didSelectRowAt indexPath: IndexPath)
    
}

class CustomPickerVC: UIViewController {
    
    enum ViewID: String {
        case Header = "Header"
        case ItemCell = "ItemCell"
    }
    
    let customView = __CPVCView.instantiateFromNib() as __CPVCView
    
    let identifier: String
    var selectedIndex: Int
    var delegate: CustomPickerVCDelegate?
    
    /**
     - Parameters:
        - identifier: A `String` that uniquely identifies this custom picker.
        - headerTitle: The text to be displayed on top of the custom picker.
        - initiallySelectedIndex: The index that is initially selected, default is `0`.
     */
    init(identifier: String, headerTitle: String, initiallySelectedIndex: Int = 0) {
        self.identifier = identifier
        self.selectedIndex = initiallySelectedIndex
        super.init(nibName: nil, bundle: nil)
        
        self.customView.headerLabel.text = headerTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        self.customView.tableView.register(CustomPickerCell.nib(), forCellReuseIdentifier: ViewID.ItemCell.rawValue)
    }
    
    func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CustomPickerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate = self.delegate {
            return delegate.dataSource(forIdentifier: self.identifier).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPickerVC.ViewID.ItemCell.rawValue) as! CustomPickerCell
        
        cell.checkLabel.isHidden = (indexPath as NSIndexPath).row != self.selectedIndex
        
        if let delegate = self.delegate {
            cell.itemLabel.text = delegate.text(forIndexPath: indexPath)
        }
        
        return cell
    }
    
}

extension CustomPickerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.row {
            let previousIndexPath = IndexPath(row: self.selectedIndex, section: 0)
            let indexPathsToReload = [previousIndexPath, indexPath]
            self.selectedIndex = indexPath.row
            tableView.reloadRows(at: indexPathsToReload, with: .none)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.customPicker(self, didSelectRowAt: indexPath)
    }
    
}
