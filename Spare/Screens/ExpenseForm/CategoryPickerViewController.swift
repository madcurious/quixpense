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
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategorySelection)
}

private enum ViewID: String {
    case itemCell = "itemCell"
}

private enum Section: Int {
    case allCategories = 0
    case add = 1
    
    init(_ section: Int) {
        switch section {
        case 0:
            self = .allCategories
        case 1:
            self = .add
        default:
            fatalError()
        }
    }
}

fileprivate weak var delegate: ExpenseFormViewController?
fileprivate var globalSelectedCategory = CategorySelection.none

class CategoryPickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedCategory: CategorySelection) {
        globalSelectedCategory = selectedCategory
        let picker = CategoryPickerViewController(nibName: nil, bundle: nil)
        picker.delegate = presenter
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    lazy var internalNavigationController = SlideUpPickerViewController.makeInternalNavigationController()
    
    var delegate: CategoryPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internalNavigationController.setViewControllers([CategoryListViewController(container: self)], animated: false)
        embedChildViewController(internalNavigationController, toView: customView.contentView, fillSuperview: true)
    }
    
}

@objc extension CategoryPickerViewController {
    
    override func handleTapOnDimView() {
        dismiss(animated: true, completion: nil)
    }
    
}

fileprivate class CategoryListViewController: UITableViewController {
    
    /// Fetch controller for all categories except "Uncategorized"
    let categoryFetcher: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Category.name), DefaultClassifier.uncategorized.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: true)]
        return NSFetchedResultsController<Category>(fetchRequest: fetchRequest,
                                                    managedObjectContext: Global.coreDataStack.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
    }()
    
    unowned var container: CategoryPickerViewController
    var categories = [CategorySelection]()
    
    init(container: CategoryPickerViewController) {
        self.container = container
        super.init(style: .grouped)
        title = "Categories"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        buildDataSource()
        tableView.reloadData()
    }
    
    func buildDataSource() {
        do {
            categories = []
            
            // Fetch the categories.
            try categoryFetcher.performFetch()
            if let objects = categoryFetcher.fetchedObjects {
                for category in objects {
                    categories.append(.id(category.objectID))
                }
            }
            
            // If there is an initial selection and it is a user-entered name,
            // add it to the data source as well.
            if case .name(let enteredName) = globalSelectedCategory {
                // Find the insertion index for the user-entered name in an ascending-ordered list of names.
                let insertionIndex: Int = {
                    guard let categories = categoryFetcher.fetchedObjects
                        else {
                            return 0
                    }
                    let index = categories.index(where: {
                        guard let categoryName = $0.name
                            else {
                                return true
                        }
                        let comparison = enteredName.compare(categoryName)
                        return comparison == .orderedAscending
                    })
                    return index ?? 0
                }()
                categories.insert(globalSelectedCategory, at: insertionIndex)
            }
        }
        catch { }
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
            return categories.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        switch Section(indexPath.section) {
        case .allCategories:
            let category = categories[indexPath.row]
            if case .id(let objectID) = category,
                let categoryName = (Global.coreDataStack.viewContext.object(with: objectID) as? Category)?.name {
                cell.nameLabel.text = categoryName
            } else if case .name(let categoryName) = category {
                cell.nameLabel.text = categoryName
            }
            cell.accessoryImageType = .check
            cell.showsAccessoryImage = category == globalSelectedCategory
            
        case .add:
            cell.accessoryImageType = .add
            cell.showsAccessoryImage = true
            cell.nameLabel.text = "Add a new category"
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CategoryListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(indexPath.section) {
        case .allCategories:
            if globalSelectedCategory != .none,
                let oldIndex = categories.index(of: globalSelectedCategory),
                
                // cellForRow returns nil if the cell is not visible.
                let oldCell = tableView.cellForRow(at: IndexPath(row: oldIndex, section: Section.allCategories.rawValue)) as? PickerItemCell {
                oldCell.showsAccessoryImage = false
            }
            
            globalSelectedCategory = categories[indexPath.row]
            let newSelectionCell = tableView.cellForRow(at: indexPath) as! PickerItemCell
            newSelectionCell.showsAccessoryImage = true
            
            if let delegate = container.delegate {
                delegate.categoryPicker(container, didSelectCategory: globalSelectedCategory)
            }
            dismiss(animated: true, completion: nil)
            
        case .add:
            let newScreen = NewClassifierViewController(classifierType: .category, successAction: {[unowned self] name in
                globalSelectedCategory = .name(name)
                if let delegate = self.container.delegate {
                    delegate.categoryPicker(self.container, didSelectCategory: globalSelectedCategory)
                }
                self.dismiss(animated: true, completion: nil)
            })
            navigationController?.pushViewController(newScreen, animated: true)
        }
    }
    
}
