//
//  TagPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 05/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

protocol TagPickerViewControllerDelegate {
    func tagPicker(_ picker: TagPickerViewController, didSelectTags tags: TagSelection)
}

fileprivate var globalSelectedTags = TagSelection.none

/// Container for the entire tag picker. Internally manages a navigation controller where the
/// first screen is the list of tags, and the second screen is for adding a new tag.
class TagPickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedTags: TagSelection) {
        globalSelectedTags = selectedTags
        let picker = TagPickerViewController(nibName: nil, bundle: nil)
        picker.delegate = presenter
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    private lazy var internalNavigationController = SlideUpPickerViewController.makeInternalNavigationController()
    var delegate: TagPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internalNavigationController.setViewControllers([TagListViewController(container: self)], animated: false)
        embedChildViewController(internalNavigationController, toView: customView.contentView, fillSuperview: true)
    }
    
}

@objc extension TagPickerViewController {
    
    override func handleTapOnDimView() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        if let delegate = delegate {
            delegate.tagPicker(self, didSelectTags: globalSelectedTags)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TagListViewController

private enum ViewID: String {
    case itemCell = "itemCell"
}

private enum Section: Int {
    case allTags, add
    init(_ section: Int) {
        switch section {
        case 0:
            self = .allTags
        case 1:
            self = .add
        default:
            fatalError()
        }
    }
    static let all: [Section] = [.allTags, .add]
}

/// Internal view controller that contains the list of tags.
fileprivate class TagListViewController: UIViewController {
    
    let tagFetcher: NSFetchedResultsController<Tag> = {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Tag.name), DefaultClassifier.untagged.name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Global.coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    unowned var container: TagPickerViewController
    
    var selectionList: [TagSelection.Member] = []
    
    init(container: TagPickerViewController) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
        title = "Tags"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: container, action: #selector(TagPickerViewController.handleTapOnCancelButton))
        navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: container, action: #selector(TagPickerViewController.handleTapOnDoneButton))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        buildSelectionList()
        tableView.reloadData()
    }
    
    func buildSelectionList() {
        do {
            selectionList = []
            
            // Fetch the tags.
            try tagFetcher.performFetch()
            if let tags = tagFetcher.fetchedObjects {
                tags.forEach {
                    selectionList.append(.id($0.objectID))
                }
            }
            
            // If there are initially selected user-entered names, add them to the data source as well.
            switch globalSelectedTags {
            case .list(let list) where list.isEmpty == false:
                for member in list {
                    switch member {
                    case .name(let enteredName):
                        if let index = insertionIndex(for: enteredName) {
                            selectionList.insert(.name(enteredName), at: index)
                        }
                    default:
                        continue
                    }
                }
            default: break
            }
        } catch { }
    }
    
    func currentSelectionListAsStrings() -> [String] {
        let list = selectionList.flatMap {
            switch $0 {
            case .id(let objectID):
                guard let tagName = (Global.coreDataStack.viewContext.object(with: objectID) as? Tag)?.name
                    else {
                        return nil
                }
                return tagName
            case .name(let tagName):
                return tagName
            }
        }
        return list
    }
    
    // Find the insertion index for the user-entered name in an ascending-ordered list of names.
    // The data source should have been populated with the existing tags before this function is called.
    func insertionIndex(for name: String) -> Int? {
        // May return nil if the data source already contains the string.
        let index = currentSelectionListAsStrings().index(where: { name.compare($0) == .orderedAscending })
        return index
    }
    
}

// MARK: UITableViewDataSource

extension TagListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allTags:
            return selectionList.count
        case .add:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        switch Section(rawValue: indexPath.section)! {
        case .allTags:
            // Update the cell appearance depending on whether the tag will be selected/deselected.
            let member = selectionList[indexPath.row]
            cell.nameLabel.text = {
                if case .id(let objectID) = member,
                    let tagName = (Global.coreDataStack.viewContext.object(with: objectID) as? Tag)?.name {
                    return tagName
                } else if case .name(let tagName) = member {
                    return tagName
                }
                return nil
            }()
            cell.accessoryImageType = .check
            cell.showsAccessoryImage = {
                if case .list(let list) = globalSelectedTags,
                    list.contains(member) {
                    return true
                }
                return false
            }()
            
        case .add:
            cell.accessoryImageType = .add
            cell.showsAccessoryImage = true
            cell.nameLabel.text = "Add a new tag"
        }
        
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension TagListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(rawValue: indexPath.section)! {
        case .allTags:
            let tag = selectionList[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! PickerItemCell
            
            // If there is a set of selections, insert or remove the tag
            // depending on whether it is already contained or not.
            if case .list(var list) = globalSelectedTags,
                list.isEmpty == false {
                if let index = list.index(of: tag) {
                    list.remove(at: index)
                    cell.showsAccessoryImage = false
                } else {
                    list.append(tag)
                    cell.showsAccessoryImage = true
                }
                globalSelectedTags = .list(list)
            }
                
                // Otherwise, initialize a set of selections with the tag in it.
            else {
                cell.showsAccessoryImage = true
                globalSelectedTags = .list([tag])
            }
            
        case .add:
            let newClassifierScreen = NewClassifierViewController(classifierType: .tag)
            newClassifierScreen.delegate = self
            navigationController?.pushViewController(newClassifierScreen, animated: true)
        }
    }
    
}

// MARK: - NewClassifierViewControllerDelegate

extension TagListViewController: NewClassifierViewControllerDelegate {
    
    func newClassifierViewController(_ newClassifierViewController: NewClassifierViewController, didEnter classifierName: String?) {
        guard let enteredName = classifierName?.trim(),
            enteredName.isEmpty == false
            else {
                MDAlertDialog.showInPresenter(self, title: nil, message: "You must enter a tag name.", cancelButtonTitle: "Got it!")
                return
        }
        
        // Don't allow duplicate additions.
        if currentSelectionListAsStrings().contains(enteredName) {
            MDAlertDialog.showInPresenter(self, title: nil, message: "You already have a tag named '\(enteredName).'", cancelButtonTitle: "Got it!")
            return
        }
        
        // Update the tag selection.
        switch globalSelectedTags {
        case .list(var list) where list.isEmpty == false:
            list.append(.name(enteredName))
            globalSelectedTags = .list(list)
        default:
            globalSelectedTags = .list([.name(enteredName)])
        }
        
        // Insert the entered name to the selection list and check the cell.
        if let insertionIndex = insertionIndex(for: enteredName) {
            selectionList.insert(.name(enteredName), at: insertionIndex)
            tableView.reloadData()
            
            let indexPath = IndexPath(row: insertionIndex, section: Section.allTags.rawValue)
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            let cell = tableView.cellForRow(at: indexPath) as! PickerItemCell
            cell.showsAccessoryImage = true
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
