//
//  EFEVCDatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 30/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate enum ViewID: String {
    case switchCell = "switchCell"
    case datePickerCell = "datePickerCell"
}

class EFEVCDatePickerVC: UIViewController {
    
    var dateRange = DateRange()
    let tableView = UITableView(frame: .zero, style: .grouped)
    var hasFromDate = true
    var hasToDate = true
    
    override func loadView() {
        self.tableView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.back, target: self, action: #selector(handleTapOnBackButton))
        self.navigationItem.title = "DATE"
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
        
        self.tableView.register(_EFEVCDPVCSwitchCell.nib(), forCellReuseIdentifier: ViewID.switchCell.rawValue)
        self.tableView.register(_EFEVCDPVCDatePickerCell.nib(), forCellReuseIdentifier: ViewID.datePickerCell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func handleTapOnBackButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleTapOnDoneButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension EFEVCDatePickerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.hasFromDate {
                return 2
            }
            return 1
            
        default:
            if self.hasToDate {
                return 2
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (1, 0):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.switchCell.rawValue) as! _EFEVCDPVCSwitchCell
            if indexPath.section == 0 {
                cell.bound = DateRange.Bound.from
                cell.isOn = self.hasFromDate
            } else {
                cell.bound = DateRange.Bound.to
                cell.isOn = self.hasToDate
            }
            cell.delegate = self
            return cell
            
        case (0, 1), (1, 1):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.datePickerCell.rawValue) as! _EFEVCDPVCDatePickerCell
            cell.delegate = self
            return cell
            
        default:
            fatalError("Unknown indexPath in EFEVCDatePickerVC \(indexPath)")
        }
    }
    
}

extension EFEVCDatePickerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44 // UITableViewCell height
        } else {
            return 216 // UIDatePicker height
        }
    }
    
}

extension EFEVCDatePickerVC: _EFEVCDPVCSwitchCellDelegate {
    
    func switchCellDidToggle(_ on: Bool, for bound: DateRange.Bound) {
        switch bound {
        case .from:
            self.hasFromDate = on
            let indexPath = IndexPath(row: 1, section: 0)
            if on {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            } else {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .to:
            self.hasToDate = on
            let indexPath = IndexPath(row: 1, section: 1)
            if on {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            } else {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}

extension EFEVCDatePickerVC: _EFEVCDPVCDatePickerCellDelegate {
    
    func datePickerCellDidChangeDate(_ date: Date, for bound: DateRange.Bound) {
        if bound == .from {
            self.dateRange.from = date
        } else {
            self.dateRange.to = date
        }
    }
    
}
