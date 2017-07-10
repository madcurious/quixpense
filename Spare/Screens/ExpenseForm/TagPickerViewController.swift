//
//  TagPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 05/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

private enum ViewID: String {
    case itemCell = "itemCell"
}

class TagPickerViewController: UIViewController {
    
    class func present(from presenter: ExpenseFormViewController) {
        let picker = TagPickerViewController()
        picker.setCustomTransitioningDelegate(SlideUpPicker.sharedTransitioningDelegate)
//        picker.delegate = presenter
        presenter.present(picker, animated: true, completion: nil)
    }
    
    let customView = TagPickerView.instantiateFromNib()
    
    let allTagsFetcher: NSFetchedResultsController<Tag> = {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Global.coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var selectedTags = Set<NSManagedObjectID>()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        self.customView.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
        self.customView.tableView.rowHeight = UITableViewAutomaticDimension
        self.customView.tableView.estimatedRowHeight = 44
        
        do {
            try self.allTagsFetcher.performFetch()
            self.customView.tableView.reloadData()
        } catch{}
    }
    
    func tag(at index: UInt) -> Tag {
        return self.allTagsFetcher
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TagPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return self.allTagsFetcher.fetchedObjects?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        switch indexPath.section {
        case 0, 1:
            break
        default:
            cell.nameLabel.text = self.allTagsFetcher.object(at: IndexPath(item: indexPath.item, section: 0)).name
        }
        
        return cell
    }
    
}

extension TagPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0, 2:
            let tag = self.allTagsFetcher.object(at: IndexPath(row: indexPath.row, section: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recent"
        case 1:
            return nil
        default:
            return "All tags"
        }
    }
    
}
