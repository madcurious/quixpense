//
//  __HVCCardCell.swift
//  Spare
//
//  Created by Matt Quiros on 21/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCCardCell: UICollectionViewCell {
    
    var customContentView: __HVCCardCellContentView
    
    override init(frame: CGRect) {
        self.customContentView = __HVCCardCellContentView.instantiateFromNib()
        super.init(frame: frame)
        self.contentView.addSubviewAndFill(self.customContentView)
        
        self.customContentView.tableView.dataSource = self
        self.customContentView.tableView.delegate = self
        self.customContentView.tableView.rowHeight = 44
        
        self.setNeedsLayout()
        self.customContentView.setNeedsLayout()
        self.layoutIfNeeded()
        self.customContentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension __HVCCardCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellID"
        let cell: UITableViewCell
        if let reusableCell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        cell.textLabel?.text = "Label \(indexPath.row + 1)"
        return cell
    }
    
}

extension __HVCCardCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
