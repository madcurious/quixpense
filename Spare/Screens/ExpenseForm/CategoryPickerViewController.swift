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
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: CategoryArgument)
}

private enum ViewID: String {
    case itemCell = "itemCell"
}

private enum Section: Int {
    case allCategories = 0
    case options = 1
    
    init(_ section: Int) {
        switch section {
        case 0:
            self = .allCategories
        case 1:
            self = .options
        default:
            fatalError()
        }
    }
}

private enum Option: Int {
    case clear = 0
    case new = 1
    
    init(_ option: Int) {
        switch option {
        case 0:
            self = .clear
        case 1:
            self = .new
        default:
            fatalError()
        }
    }
    
    static let all: [Option] = [.clear, .new]
}

fileprivate weak var delegate: ExpenseFormViewController?
fileprivate var globalSelectedCategory = CategoryArgument.none

class CategoryPickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedCategory: CategoryArgument) {
        let picker = CategoryPickerViewController(selectedCategory: selectedCategory)
        picker.delegate = presenter
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    lazy var internalNavigationController = SlideUpPickerViewController.makeInternalNavigationController()
    
    var delegate: CategoryPickerViewControllerDelegate?
    
    private init(selectedCategory: CategoryArgument) {
        globalSelectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.internalNavigationController.setViewControllers([CategoryListViewController(container: self)], animated: false)
        self.embedChildViewController(self.internalNavigationController, toView: self.customView.contentView, fillSuperview: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

@objc extension CategoryPickerViewController {
    
    func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
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
    var categories = [CategoryArgument]()
    
    init(container: CategoryPickerViewController) {
        self.container = container
        super.init(style: .grouped)
        self.title = "Categories"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.buildDataSource()
        self.tableView.reloadData()
    }
    
    func performFetch() {
        do {
            try self.categoryFetcher.performFetch()
            self.tableView.reloadData()
        } catch { }
    }
    
    func buildDataSource() {
        do {
            self.categories = []
            
            // Fetch the categories.
            try self.categoryFetcher.performFetch()
            if let categories = self.categoryFetcher.fetchedObjects {
                for category in categories {
                    self.categories.append(.id(category.objectID))
                }
            }
            
            // If there is an initial selection and it is a user-entered name,
            // add it to the data source as well.
            if case .name(let enteredName) = globalSelectedCategory {
                // Find the insertion index for the user-entered name in an ascending-ordered list of names.
                let insertionIndex: Int = {
                    guard let categories = self.categoryFetcher.fetchedObjects
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
                self.categories.insert(globalSelectedCategory, at: insertionIndex)
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
            return self.categories.count
        default:
            return Option.all.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        switch Section(indexPath.section) {
        case .allCategories:
            let category = self.categories[indexPath.row]
            if case .id(let objectID) = category,
                let categoryName = (Global.coreDataStack.viewContext.object(with: objectID) as? Category)?.name {
                cell.nameLabel.text = categoryName
            } else if case .name(let categoryName) = category {
                cell.nameLabel.text = categoryName
            }
            cell.isActive = category == globalSelectedCategory
            
        case .options:
            switch Option(indexPath.row) {
            case .clear:
                cell.nameLabel.text = "Clear category"
            case .new:
                cell.nameLabel.text = "Add a new category"
            }
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
                let oldIndex = self.categories.index(of: globalSelectedCategory),
                
                // cellForRow returns nil if the cell is not visible.
                let oldCell = self.tableView.cellForRow(at: IndexPath(row: oldIndex, section: Section.allCategories.rawValue)) as? PickerItemCell {
                
                oldCell.isActive = false
            }
            
            globalSelectedCategory = self.categories[indexPath.row]
            let newSelectionCell = self.tableView.cellForRow(at: indexPath) as! PickerItemCell
            newSelectionCell.isActive = true
            
            if let delegate = self.container.delegate {
                delegate.categoryPicker(self.container, didSelectCategory: globalSelectedCategory)
            }
            self.dismiss(animated: true, completion: nil)
            
        case .options:
            switch Option(indexPath.row) {
            case .clear:
                if let delegate = self.container.delegate {
                    delegate.categoryPicker(self.container, didSelectCategory: .none)
                }
                self.dismiss(animated: true, completion: nil)
                
            case .new:
                let newScreen = NewClassifierViewController(classifierType: .category, successAction: {[unowned self] name in
                    globalSelectedCategory = .name(name)
                    if let delegate = self.container.delegate {
                        delegate.categoryPicker(self.container, didSelectCategory: globalSelectedCategory)
                    }
                    self.dismiss(animated: true, completion: nil)
                })
                self.navigationController?.pushViewController(newScreen, animated: true)
                
            }
        }
    }
    
}
