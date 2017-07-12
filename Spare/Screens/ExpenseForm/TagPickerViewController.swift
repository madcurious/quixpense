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

private enum ViewID: String {
    case itemCell = "itemCell"
}

private enum Section: Int {
    case recents, allTags, newTag
}

fileprivate var kSelectedTags = Set<NSManagedObjectID>()

/// Container for the entire tag picker. Internally manages a navigation controller where the
/// first screen is the list of tags, and the second screen is for adding a new tag.
class TagPickerViewController: SlideUpPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController, selectedTags: Set<NSManagedObjectID>?) {
        let picker = TagPickerViewController(selectedTags: selectedTags)
        SlideUpPickerViewController.present(picker, from: presenter)
    }
    
    private lazy var internalNavigationController = SlideUpPickerViewController.makeInternalNavigationController()
    
    init(selectedTags: Set<NSManagedObjectID>?) {
        super.init(nibName: nil, bundle: nil)
        if let selectedTags = selectedTags {
            kSelectedTags = selectedTags
        } else {
            kSelectedTags.removeAll()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.internalNavigationController.setViewControllers([TagListViewController()], animated: false)
        self.embedChildViewController(self.internalNavigationController, toView: self.customView.contentView, fillSuperview: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TagListViewController

/// Internal view controller that contains the list of tags.

fileprivate class TagListViewController: UIViewController {
    
    let tagFetcher: NSFetchedResultsController<Tag> = {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Tag.name), DefaultClassifier.untagged.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Global.coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func loadView() {
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.performFetch()
    }
    
    func performFetch() {
        do {
            try self.tagFetcher.performFetch()
            self.tableView.reloadData()
        } catch { }
    }
    
    func tag(at indexPath: IndexPath) -> Tag {
        let section = Section(rawValue: indexPath.section)!
        if section == .allTags {
            return self.tagFetcher.object(at: IndexPath(item: indexPath.row, section: 0))
        }
        // Recents
        return self.tagFetcher.object(at: IndexPath(item: indexPath.item, section: 0))
    }
    
}

// MARK: UITableViewDataSource

extension TagListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allTags:
            return self.tagFetcher.fetchedObjects?.count ?? 0
        case .newTag:
            return 1
        case .recents:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        switch Section(rawValue: indexPath.section)! {
            
        case .allTags:
            let tag = self.tag(at: indexPath)
            cell.nameLabel.text = tag.name
            cell.isActive = kSelectedTags.contains(tag.objectID)
            
        case .newTag:
            cell.nameLabel.text = "Add a new tag"
            cell.isActive = kSelectedTags.contains(self.tag(at: indexPath).objectID)
            
        case .recents:
            break
        }
        
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension TagListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(rawValue: indexPath.section)! {
        case .allTags, .recents:
            let tagID = self.tag(at: indexPath).objectID
            if kSelectedTags.contains(tagID) {
                kSelectedTags.remove(tagID)
            } else {
                kSelectedTags.insert(tagID)
            }
            let cell = self.tableView.cellForRow(at: indexPath) as! PickerItemCell
            cell.isActive = kSelectedTags.contains(tagID)
            
        case .newTag:
            let addScreen = NewClassifierViewController(classifierType: .tag, successAction: {[unowned self] name in
                let newTag = Tag(context: Global.coreDataStack.viewContext)
                newTag.name = name
                
                kSelectedTags.insert(newTag.objectID)
                self.performFetch()
                
                var tagIndexPath = self.tagFetcher.indexPath(forObject: newTag)!
                tagIndexPath.section = Section.allTags.rawValue
                self.tableView.scrollToRow(at: tagIndexPath, at: .top, animated: false)
            })
            self.navigationController?.pushViewController(addScreen, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .allTags:
            return "All tags"
        case .newTag:
            return nil
        case .recents:
            return "Recent"
        }
    }
    
}
