//
//  ExpenseFilterPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

fileprivate enum ViewID: String {
    case expenseFilterCell = "expenseFilterCell"
    case newFilterCell = "newFilterCell"
}

class ExpenseFilterPickerVC: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let fetchedResultsController: NSFetchedResultsController<ExpenseFilter> = {
        let fetchRequest = FetchRequest<ExpenseFilter>.make()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ExpenseFilter.displayOrder), ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Global.coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: "ExpenseFilterPickerVCCache")
        return fetchedResultsController
    }()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func loadView() {
        self.tableView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.title = "FILTER"
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ExpenseFilterCell.nib(), forCellReuseIdentifier: ViewID.expenseFilterCell.rawValue)
        self.tableView.register(NewFilterCell.nib(), forCellReuseIdentifier: ViewID.newFilterCell.rawValue)
        
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {}
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
            return self.fetchedResultsController.fetchedObjects?.count ?? 1
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.expenseFilterCell.rawValue) as! ExpenseFilterCell
            cell.filter = self.fetchedResultsController.fetchedObjects?[indexPath.row]
            cell.isChecked = self.selectedIndexPath == indexPath
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
        
        if indexPath.section == 0 &&
            indexPath != self.selectedIndexPath {
            let oldIndexPath = self.selectedIndexPath
            self.selectedIndexPath = indexPath
            self.tableView.reloadRows(at: [oldIndexPath, indexPath], with: .automatic)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ExpenseFilterPickerVC: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
}
