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

private enum Section: Int {
    case allCategories = 0
    case newCategory = 1
}

fileprivate var kSelectedCategoryID: NSManagedObjectID?
fileprivate weak var delegate: ExpenseFormViewController?

class CategoryPickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedCategoryID: NSManagedObjectID?) {
        let picker = CategoryPickerViewController(selectedCategoryID: selectedCategoryID)
        picker.delegate = presenter
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    lazy var internalNavigationController = SlideUpPickerViewController.makeInternalNavigationController()
    
    var delegate: CategoryPickerViewControllerDelegate?
    
    init(selectedCategoryID: NSManagedObjectID?) {
        super.init(nibName: nil, bundle: nil)
        kSelectedCategoryID = selectedCategoryID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.internalNavigationController.setViewControllers([CategoryListViewController()], animated: false)
        self.embedChildViewController(self.internalNavigationController, toView: self.customView.contentView, fillSuperview: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

fileprivate class CategoryListViewController: UITableViewController {
    
    let categoryFetcher: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Category.name), DefaultClassifier.uncategorized.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: true)]
        return NSFetchedResultsController<Category>(fetchRequest: fetchRequest,
                                                    managedObjectContext: Global.coreDataStack.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
    }()
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.performFetch()
    }
    
    func performFetch() {
        do {
            try self.categoryFetcher.performFetch()
            self.tableView.reloadData()
        } catch {}
    }
    
}

// MARK: UITableViewDataSource

extension CategoryListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.allCategories.rawValue:
            return self.categoryFetcher.fetchedObjects?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        if indexPath.section == Section.allCategories.rawValue {
            let category = self.categoryFetcher.object(at: indexPath)
            cell.nameLabel.text = category.name
            cell.isActive = category.objectID == kSelectedCategoryID
        } else {
            cell.nameLabel.text = "Label"
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CategoryListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(rawValue: indexPath.section)! {
        case .allCategories:
            guard let currentCategory = self.categoryFetcher.fetchedObjects?.first(where: { $0.objectID == kSelectedCategoryID }),
                let currentlySelectedIndexPath = self.categoryFetcher.indexPath(forObject: currentCategory)
                else {
                    // If there isn't an initially selected category, simply check the category at the indexPath.
                    let category = self.categoryFetcher.object(at: indexPath)
                    kSelectedCategoryID = category.objectID
                    let cell = self.tableView.cellForRow(at: indexPath) as! PickerItemCell
                    cell.isActive = true
                    return
            }
            
            // If the same category is tapped, deselect.
            if currentlySelectedIndexPath == indexPath {
                kSelectedCategoryID = nil
                let cell = self.tableView.cellForRow(at: currentlySelectedIndexPath) as! PickerItemCell
                cell.isActive = false
            }
                
                // Otherwise, update the location of the check mark.
            else {
                let category = self.categoryFetcher.object(at: indexPath)
                kSelectedCategoryID = category.objectID
                let oldSelectionCell = self.tableView.cellForRow(at: currentlySelectedIndexPath) as! PickerItemCell
                oldSelectionCell.isActive = false
                let newSelectionCell = self.tableView.cellForRow(at: indexPath) as! PickerItemCell
                newSelectionCell.isActive = true
            }
            
        case .newCategory:
            let newScreen = NewClassifierViewController(classifierType: .category, successAction: {[unowned self] name in
                let newCategory = Category(context: Global.coreDataStack.viewContext)
                newCategory.name = name
                kSelectedCategoryID = newCategory.objectID
                
                self.performFetch()
                let indexPath = self.categoryFetcher.indexPath(forObject: newCategory)!
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            })
            self.navigationController?.pushViewController(newScreen, animated: true)
        }
    }
    
}
