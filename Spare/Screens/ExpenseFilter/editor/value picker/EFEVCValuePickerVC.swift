//
//  EFEVCValuePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 04/04/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

protocol EFEVCValuePickerVCDelegate {
    
    func text(for value: NSManagedObject) -> String?
    func didSelect(indexPaths: [IndexPath])
    
}

fileprivate enum ViewID: String {
    case valueCell = "valueCell"
}

class EFEVCValuePickerVC<T: NSManagedObject>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var selectedIndexPaths = Set<IndexPath>()
    var delegate: EFEVCValuePickerVCDelegate
    let fetchedResultsController: NSFetchedResultsController<T>
    
    init(title: String, sortDescriptors:[NSSortDescriptor], selectedIndexPaths: [IndexPath]?, delegate: EFEVCValuePickerVCDelegate) {
        let fetchRequest = FetchRequest<T>.make()
        fetchRequest.sortDescriptors = sortDescriptors
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Global.coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        if let selectedIndexPaths = selectedIndexPaths {
            self.selectedIndexPaths = Set(selectedIndexPaths)
        }
        
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.back, target: self, action: #selector(handleTapOnBackButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
        
        self.tableView.register(ValuePickerCell.nib(), forCellReuseIdentifier: ViewID.valueCell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {}
    }
    
    func handleTapOnBackButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleTapOnDoneButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.fetchedResultsController.fetchedObjects?.count
            else {
                return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.valueCell.rawValue) as! ValuePickerCell
        cell.indexPath = indexPath
        cell.isChecked = self.selectedIndexPaths.contains(indexPath)
        cell.valueLabel.text = self.delegate.text(for: self.fetchedResultsController.object(at: indexPath))
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndexPaths.contains(indexPath) {
            self.selectedIndexPaths.remove(indexPath)
            if let cell = self.tableView.cellForRow(at: indexPath) as? ValuePickerCell {
                cell.isChecked = false
            }
        } else {
            self.selectedIndexPaths.insert(indexPath)
            if let cell = self.tableView.cellForRow(at: indexPath) as? ValuePickerCell {
                cell.isChecked = true
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

