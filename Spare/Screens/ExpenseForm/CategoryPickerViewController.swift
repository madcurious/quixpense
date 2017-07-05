//
//  CategoryPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

protocol CategoryPickerViewControllerDelegate {
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: Category)
    func categoryPicker(_ picker: CategoryPickerViewController, didAddNewCategoryName name: String)
}

private enum ViewID: String {
    case itemCell = "itemCell"
}

class CategoryPickerViewController: UIViewController {
    
    let fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: true)]
        return NSFetchedResultsController<Category>(fetchRequest: fetchRequest,
                                                    managedObjectContext: Global.coreDataStack.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
    }()
    
    let customView = CategoryPickerView.instantiateFromNib()
    var delegate: CategoryPickerViewControllerDelegate?
    var selectedCategoryID: NSManagedObjectID?
    
    init(selectedCategoryID: NSManagedObjectID?) {
        self.selectedCategoryID = selectedCategoryID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
        
        do {
            try self.fetchedResultsController.performFetch()
            
            self.customView.tableView.dataSource = self
            self.customView.tableView.delegate = self
            self.customView.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
            self.customView.tableView.rowHeight = UITableViewAutomaticDimension
            self.customView.tableView.estimatedRowHeight = 44
            
            self.customView.tableView.reloadData()
        } catch {}
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension CategoryPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.fetchedResultsController.fetchedObjects?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        if indexPath.section == 0 {
            let category = self.fetchedResultsController.object(at: indexPath)
            cell.nameLabel.text = category.name
            cell.isActive = category.objectID == self.selectedCategoryID
        } else {
            cell.nameLabel.text = "Label"
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            var reloadRows = [indexPath]
            if let currentCategory = self.fetchedResultsController.fetchedObjects?.first(where: { $0.objectID == self.selectedCategoryID }),
                let oldIndexPath = self.fetchedResultsController.indexPath(forObject: currentCategory) {
                reloadRows.append(oldIndexPath)
            }
            let category = self.fetchedResultsController.object(at: indexPath)
            self.selectedCategoryID = category.objectID
            tableView.reloadRows(at: reloadRows, with: .automatic)
            
            self.delegate?.categoryPicker(self, didSelectCategory:category)
//            self.dismiss(animated: true, completion: nil)
            
        default:
            self.dismiss(animated: true, completion: {
                let alertController = UIAlertController(title: nil, message: "Enter a new category name:", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.autocapitalizationType = .sentences
                })
                alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: {[unowned self] (_) in
                    guard let delegate = self.delegate,
                        let categoryName = alertController.textFields?.first?.text
                        else {
                            return
                    }
                    delegate.categoryPicker(self, didAddNewCategoryName: categoryName)
                    alertController.dismiss(animated: true, completion: nil)
                }))
                alertController.addCancelAction()
                md_rootViewController().present(alertController, animated: true, completion: nil)
            })
        }
    }
    
}

// MARK: - Class functions

extension CategoryPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedCategoryID: NSManagedObjectID?) {
        let picker = CategoryPickerViewController(selectedCategoryID: selectedCategoryID)
        picker.setCustomTransitioningDelegate(SlideUpPicker.sharedTransitioningDelegate)
        picker.delegate = presenter
        presenter.present(picker, animated: true, completion: nil)
    }
    
}
