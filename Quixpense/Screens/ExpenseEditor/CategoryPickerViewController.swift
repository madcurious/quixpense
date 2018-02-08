//
//  CategoryPickerViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 02/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Bedrock

class CategoryPickerViewController: UIViewController {
    
    let viewContext: NSManagedObjectContext
    let initialSelection: String?
    var categories = [String]()
    var selectedIndexPath: IndexPath?
    
    let loadableView = BRDefaultLoadableView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    enum ViewId: String {
        case cell = "cell"
    }
    
    init(viewContext: NSManagedObjectContext, initialSelection: String?) {
        self.viewContext = viewContext
        self.initialSelection = initialSelection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        loadableView.addSubviewAndFill(tableView)
        view = loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Categories"
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Expense.fetchRequest()
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = [#keyPath(Expense.category)]
        fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Expense.category), DefaultClassifier.category.storedName)
        do {
            loadableView.state = .loading
            guard let results = try viewContext.fetch(fetchRequest) as? [[String : String]]
                else {
                    loadableView.state = .error(BRError("Can't fetch categories."))
                    return
            }
            categories = results.flatMap({ $0[#keyPath(Expense.category)] }).sorted(by: { $0.compare($1) == .orderedAscending })
            
            // Reload the table view with the loaded categories.
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
            
            // Determine the initially selected index.
            if let initialSelection = initialSelection,
                let index = categories.index(of: initialSelection) {
                selectedIndexPath = IndexPath(row: index, section: 0)
            } else {
                selectedIndexPath = IndexPath(row: 0, section: 1)
            }
            
            tableView.reloadData()
            loadableView.state = .success
        } catch {
            loadableView.state = .error(error)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (categories.count > 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categories.count {
        case let count where count > 0 && section == 0:
            return count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        cell.textLabel?.text = {
            switch categories.count {
            case let count where count > 0 && indexPath.section == 0:
                return categories[indexPath.row]
            default:
                return DefaultClassifier.category.pickerName
            }
        }()
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath != selectedIndexPath,
            let oldIndexPath = selectedIndexPath {
            selectedIndexPath = indexPath
            tableView.reloadRows(at: [oldIndexPath, indexPath], with: .automatic)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
