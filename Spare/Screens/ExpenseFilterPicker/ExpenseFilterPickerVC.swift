//
//  ExpenseFilterPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate enum ViewID: String {
    case expenseFilterCell = "expenseFilterCell"
    case newFilterCell = "newFilterCell"
}

class ExpenseFilterPickerVC: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var filters = [ExpenseFilter]()
    
    override func loadView() {
        self.tableView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.title = "FILTER"
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
        
//        self.tableView.separatorColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ExpenseFilterCell.nib(), forCellReuseIdentifier: ViewID.expenseFilterCell.rawValue)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewID.newFilterCell.rawValue)
    }
    
    func handleTapOnCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ExpenseFilterPickerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.expenseFilterCell.rawValue) as! ExpenseFilterCell
            return cell
            
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.newFilterCell.rawValue)!
            return cell
        }
    }
    
}

extension ExpenseFilterPickerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
