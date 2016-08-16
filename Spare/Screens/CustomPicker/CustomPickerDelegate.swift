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
    var selectionAction: ((selectedIndex: Int) -> ())?
    
    var dataSource: [Any] {
        fatalError("Unimplemented \(#function)")
    }
    
    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }
    
    func textForItemAtIndexPath(indexPath: NSIndexPath) -> String? {
        fatalError("Unimplemented \(#function)")
    }
    
}

extension CustomPickerDelegate: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CustomPickerVC.ViewID.ItemCell.rawValue) as! CustomPickerCell
        
        cell.checkLabel.hidden = indexPath.row != self.selectedIndex
        cell.itemLabel.text = self.textForItemAtIndexPath(indexPath)
        
        return cell
    }
    
}

extension CustomPickerDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndex = self.selectedIndex
        self.selectedIndex = indexPath.row
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: previousIndex, inSection: 0), NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectionAction?(selectedIndex: self.selectedIndex)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let maxWidth = tableView.bounds.size.width - (CustomPickerCell.ItemLabelLeading + CustomPickerCell.ItemLabelTrailing)
        let sizerLabel = CustomPickerCell.sizerLabel
        sizerLabel.text = self.textForItemAtIndexPath(indexPath)
        let labelSize = sizerLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max))
        let height = CustomPickerCell.ItemLabelTop + labelSize.height + CustomPickerCell.ItemLabelBottom
        return height
    }
    
}