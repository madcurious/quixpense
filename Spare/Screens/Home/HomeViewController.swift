//
//  HomeViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

fileprivate enum ViewID: String {
    case sectionHeader = "SectionHeader"
    case groupCell = "GroupCell"
}

private let kDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .long
    df.timeStyle = .long
    return df
}()

class HomeViewController: MDLoadableViewController {
    
    let filterButton = FilterButton.instantiateFromNib()
    let customView = HomeView.instantiateFromNib()
    
//    var fetchedResultsController = HomeViewController.makeFetchedResultsController(for: Global.filter)
    var fetchedResultsController = Global.filter.makeFetchedResultsController()
    let sectionTotals = NSCache<NSString, NSDecimalNumber>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.tabBarItem.image = UIImage.templateNamed("tabIconExpenseList")
        self.navigationItem.titleView = self.filterButton
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterButton.addTarget(self, action: #selector(handleValueChangeOnFilterButton), for: .valueChanged)
        
//        self.customView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ViewID.sectionHeader.rawValue)
//        self.customView.tableView.dataSource = self
//        self.customView.tableView.delegate = self
        
        self.performFetch()
    }
    
    func performFetch() {
//        self.showView(for: .loading)
//        
//        self.sectionTotals.removeAllObjects()
//        
//        do {
//            try self.fetchedResultsController.performFetch()
//            if let count = self.fetchedResultsController.fetchedObjects?.count,
//                count == 0 {
//                self.showView(for: .empty)
//            } else {
//                self.customView.tableView.reloadData()
//                self.showView(for: .data)
//            }
//        } catch {
//            self.showView(for: .error(error))
//        }
        try! self.fetchedResultsController.performFetch()
        
        print()
        print()
        print("=========")
        for i in 0 ..< self.fetchedResultsController.sections!.count {
            print("SECTION: \(self.fetchedResultsController.sections![i].name)")
            print("NUMBER OF OBJECTS: \(self.fetchedResultsController.sections![i].numberOfObjects)")
            
            for j in 0 ..< self.fetchedResultsController.sections![i].numberOfObjects {
                print("\tOBJECT: \(self.fetchedResultsController.object(at: IndexPath(row: j, section: i)))")
            }
            
            print()
            print()
            print("=========")
            print()
            print()
        }
    }
    
    override func showView(for state: MDLoadableViewController.State) {
        super.showView(for: state)
        
        self.customView.activityIndicatorView.isHidden = state != .initial || state != .loading
        self.customView.noExpensesLabel.isHidden = state != .empty
        self.customView.tableView.isHidden = state != .data
    }
    
    func computeTotal(forSection section: Int) -> NSDecimalNumber {
        var total = NSDecimalNumber(value: 0)
        guard let groups = self.fetchedResultsController.sections?[section].objects as? [NSManagedObject]
            else {
                return total
        }
        
        groups.forEach { group in
            if let groupTotal = group.value(forKey: "total") as? NSDecimalNumber {
                total = total.adding(groupTotal)
            }
        }
        
        return total
    }
    
    class func makeFetchedResultsController(for filter: Filter) -> NSFetchedResultsController<NSFetchRequestResult> {
        switch filter.grouping {
        case .category:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: filter.entityName())
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "endDate", ascending: false),
                NSSortDescriptor(key: "total", ascending: false)
            ]
            fetchRequest.fetchBatchSize = 100
            
            return NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: Global.coreDataStack.viewContext,
                                              sectionNameKeyPath: "sectionIdentifier",
                                              cacheName: "CacheName")
            
        case .tag:
            fatalError("Unimplemented")
        }
    }

}

// MARK: - Target actions
extension HomeViewController {
    
    func handleValueChangeOnFilterButton() {
        Global.filter = self.filterButton.filter
//        self.fetchedResultsController = HomeViewController.makeFetchedResultsController(for: Global.filter)
        self.fetchedResultsController = Global.filter.makeFetchedResultsController()
        self.performFetch()
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.performFetch()
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections
            else {
                return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchedResultsController.sections?[section]
            else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let existingCell = tableView.dequeueReusableCell(withIdentifier: ViewID.groupCell.rawValue) {
            cell = existingCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: ViewID.groupCell.rawValue)
            cell.accessoryType = .disclosureIndicator
            
            if let textLabel = cell.textLabel,
                let detailTextLabel = cell.detailTextLabel {
                textLabel.font = UIFont.systemFont(ofSize: 17)
                detailTextLabel.font = UIFont.systemFont(ofSize: 17)
            }
        }
        
        if let group = self.fetchedResultsController.object(at: indexPath) as? NSManagedObject,
            let classifierName = group.value(forKeyPath: "classifier.name") as? String,
            let total = group.value(forKey: "total") as? NSDecimalNumber {
            cell.textLabel?.text = classifierName
            cell.detailTextLabel?.text = AmountFormatter.displayText(for: total)
        } else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let existingView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewID.sectionHeader.rawValue)!
        let headerView: HomeSectionHeader
            
        if let existingHeader = existingView.subviews.first(where: {$0 is HomeSectionHeader}) as? HomeSectionHeader {
            headerView = existingHeader
        } else {
            headerView = HomeSectionHeader.instantiateFromNib()
            existingView.addSubviewsAndFill(headerView)
        }
        
        if let sectionIdentifier = self.fetchedResultsController.sections?[section].name {
            headerView.sectionIdentifier = self.fetchedResultsController.sections?[section].name
            headerView.sectionTotal = {
                if let total = self.sectionTotals.object(forKey: sectionIdentifier as NSString) {
                    return total
                } else {
                    let total = self.computeTotal(forSection: section)
                    self.sectionTotals.setObject(total, forKey: sectionIdentifier as NSString)
                    return total
                }
            }()
        }
        
        return existingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
}
