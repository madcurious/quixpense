//
//  CustomPickerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 16/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerDelegate: NSObject {
    
    var selectedIndex: Int
    var selectionAction: ((_ selectedIndex: Int) -> ())?
    
    var dataSource: [Any] {
        fatalError("Unimplemented \(#function)")
    }
    
    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }
    
    func textForItemAtIndexPath(_ indexPath: IndexPath) -> String? {
        fatalError("Unimplemented \(#function)")
    }
    
}

extension CustomPickerDelegate: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPickerVC.ViewID.ItemCell.rawValue) as! CustomPickerCell
        
        cell.checkLabel.isHidden = (indexPath as NSIndexPath).row != self.selectedIndex
        cell.itemLabel.text = self.textForItemAtIndexPath(indexPath)
        
        return cell
    }
    
}

extension CustomPickerDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndex = self.selectedIndex
        self.selectedIndex = (indexPath as NSIndexPath).row
        tableView.reloadRows(at: [IndexPath(row: previousIndex, section: 0), IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectionAction?(self.selectedIndex)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxWidth = tableView.bounds.size.width - (CustomPickerCell.ItemLabelLeading + CustomPickerCell.ItemLabelTrailing)
        let sizerLabel = CustomPickerCell.sizerLabel
        sizerLabel.text = self.textForItemAtIndexPath(indexPath)
        let labelSize = sizerLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = CustomPickerCell.ItemLabelTop + labelSize.height + CustomPickerCell.ItemLabelBottom
        return height
    }
    
}
