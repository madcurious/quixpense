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
    var selectedIndex = 0
    var categories = [String]()
    
    let loadableView = BRDefaultLoadableView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    enum ViewId: String {
        case cell = "cell"
    }
    
    init(viewContext: NSManagedObjectContext, initialSelection: String?) {
        self.viewContext = viewContext
        self.initialSelection = initialSelection
        self.selectedIndex = 0
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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(handleTapOnDoneButton))
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Expense.fetchRequest()
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = [#keyPath(Expense.category)]
        do {
            loadableView.state = .loading
            guard let results = try viewContext.fetch(fetchRequest) as? [[String : String]]
                else {
                    loadableView.state = .error(BRError("Can't fetch categories."))
                    return
            }
            
            // Map the results to an array of strings sorted alphabetically,
            // but where the default category always comes first.
            categories = results.flatMap({ $0[#keyPath(Expense.category)] }).sorted(by: {
                switch ($0, $1) {
                case _ where $0 == Classifier.category.default:
                    return true
                case _ where $1 == Classifier.category.default:
                    return false
                default:
                    return $0.compare($1) == .orderedAscending
                }
            })
            
            // Reload the table view with the loaded categories.
            tableView.dataSource = self
            tableView.delegate = self
            
            // Determine the initially selected index.
            if let initialSelection = initialSelection,
                let index = categories.index(of: initialSelection) {
                selectedIndex = index
            } else if let index = categories.index(of: Classifier.category.default) {
                selectedIndex = index
            }
            
            tableView.reloadData()
            loadableView.state = .success
        } catch {
            loadableView.state = .error(error)
        }
    }
    
}

@objc fileprivate extension CategoryPickerViewController {
    
//    func handleTapOnDoneButton() {
//        navigationController?.popViewController(animated: true)
//    }
    
}

// MARK: - UITableViewDataSource
extension CategoryPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue) {
                return reusableCell
            }
            let newCell = UITableViewCell(style: .default, reuseIdentifier: ViewId.cell.rawValue)
            return newCell
        }()
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != selectedIndex {
            let oldIndexPath = IndexPath(row: selectedIndex, section: 0)
            selectedIndex = indexPath.row
            tableView.reloadRows(at: [oldIndexPath, indexPath], with: .automatic)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
