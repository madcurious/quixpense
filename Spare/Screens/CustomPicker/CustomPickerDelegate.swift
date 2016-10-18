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
    var tapAction: ((_ tappedIndex: Int) -> ())?
    
    var dataSource: [Any] {
        fatalError("Unimplemented \(#function)")
    }
    
    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }
    
    func text(forIndexPath indexPath: IndexPath) -> String? {
        fatalError("Unimplemented \(#function)")
    }
    
    func attributedString(forIndexPath indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func setText(forLabel label: UILabel, atIndexPath indexPath: IndexPath) {
        if let attributedString = self.attributedString(forIndexPath: indexPath) {
            label.attributedText = attributedString
        } else if let text = self.text(forIndexPath: indexPath) {
            label.text = text
        } else {
            label.text = nil
        }
    }
    
    func shouldSelectItem(atIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension CustomPickerDelegate: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPickerVC.ViewID.ItemCell.rawValue) as! CustomPickerCell
        
        cell.checkLabel.isHidden = (indexPath as NSIndexPath).row != self.selectedIndex
        
        self.setText(forLabel: cell.itemLabel, atIndexPath: indexPath)
        
        return cell
    }
    
}

extension CustomPickerDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.shouldSelectItem(atIndexPath: indexPath) == true {
            let previousIndexPath = IndexPath(row: self.selectedIndex, section: 0)
            let indexPathsToReload = [previousIndexPath, indexPath]
            self.selectedIndex = indexPath.row
            
            tableView.reloadRows(at: indexPathsToReload, with: .none)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tapAction?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxWidth = tableView.bounds.size.width - (CustomPickerCell.ItemLabelLeading + CustomPickerCell.ItemLabelTrailing)
        let sizerLabel = CustomPickerCell.sizerLabel
        self.setText(forLabel: sizerLabel, atIndexPath: indexPath)
        let labelSize = sizerLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = CustomPickerCell.ItemLabelTop + labelSize.height + CustomPickerCell.ItemLabelBottom
        return height
    }
    
}
