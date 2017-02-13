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
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let fields = [
        [
            "Currency",
            "Start of week"
        ],
        [
            "Screen on launch"
        ],
        [
            "Manage categories"
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
        self.edgesForExtendedLayout = .bottom
        
        self.tableView.backgroundColor = Color.UniversalBackgroundColor
        self.view.addSubviewAndFill(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
}

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.fields[section]
        return section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = {
            switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
            case (2, 0):
                return ViewID.PlainCell.rawValue
                
            default:
                return ViewID.FieldValueCell.rawValue
            }
        }()
        
        var cell: UITableViewCell
        
        switch identifier {
        case ViewID.FieldValueCell.rawValue:
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: ViewID.FieldValueCell.rawValue) {
                cell = reusableCell
            } else {
                cell = UITableViewCell(style: .value1, reuseIdentifier: ViewID.FieldValueCell.rawValue)
                cell.accessoryType = .disclosureIndicator
            }
            
        case ViewID.PlainCell.rawValue:
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: ViewID.PlainCell.rawValue) {
                cell = reusableCell
            } else {
                cell = UITableViewCell(style: .default, reuseIdentifier: ViewID.PlainCell.rawValue)
                cell.accessoryType = .disclosureIndicator
            }
            
        default:
            fatalError("Unrecognized identifier: \(identifier)")
        }
        
        let field = self.fields[indexPath.section][indexPath.row]
        cell.textLabel?.text = field
        
        return cell
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
}
