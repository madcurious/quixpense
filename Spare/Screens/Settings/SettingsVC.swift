//
//  SettingsVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private enum ViewID: String {
    case PlainCell = "PlainCell"
    case FieldValueCell = "FieldValueCell"
}

class SettingsVC: UIViewController {
    
    let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    let fields = [
        [
            MDField(name: "Currency".uppercaseString),
            MDField(name: "Start of week".uppercaseString)
        ],
        [
            MDField(name: "Screen on launch".uppercaseString)
        ],
        [
            MDField(name: "Manage categories".uppercaseString)
        ]
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.tableView.backgroundColor = Color.ScreenBackgroundColorLightGray
        self.view.addSubviewAndFill(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
}

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fields.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.fields[section]
        return section.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = {
            switch (indexPath.section, indexPath.row) {
            case (2, 0):
                return ViewID.PlainCell.rawValue
                
            default:
                return ViewID.FieldValueCell.rawValue
            }
        }()
        
        var cell: UITableViewCell
        
        switch identifier {
        case ViewID.FieldValueCell.rawValue:
            if let reusableCell = tableView.dequeueReusableCellWithIdentifier(ViewID.FieldValueCell.rawValue) {
                cell = reusableCell
            } else {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: ViewID.FieldValueCell.rawValue)
                cell.accessoryType = .DisclosureIndicator
            }
            
        case ViewID.PlainCell.rawValue:
            if let reusableCell = tableView.dequeueReusableCellWithIdentifier(ViewID.PlainCell.rawValue) {
                cell = reusableCell
            } else {
                cell = UITableViewCell(style: .Default, reuseIdentifier: ViewID.PlainCell.rawValue)
                cell.accessoryType = .DisclosureIndicator
            }
            
        default:
            fatalError("Unrecognized identifier: \(identifier)")
        }
        
        let field = self.fields[indexPath.section][indexPath.row]
        cell.textLabel?.text = field.label
        cell.detailTextLabel?.text = field.value as? String
        
        return cell
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
}