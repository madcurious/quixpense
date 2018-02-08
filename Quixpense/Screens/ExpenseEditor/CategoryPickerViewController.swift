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
    var options: [[String?]] = [[nil], ["Add new category"]]
    var selectedIndexPath: IndexPath?
    var didSelect: ((String?) -> Void)?
    
    let loadableView = BRDefaultLoadableView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    enum ViewId: String {
        case cell = "cell"
    }
    
    init(viewContext: NSManagedObjectContext, initialSelection: String?, didSelect: ((String?) -> Void)?) {
        self.viewContext = viewContext
        self.initialSelection = initialSelection
        self.didSelect = didSelect
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
            let sortedResults = results.flatMap({ $0[#keyPath(Expense.category)] }).sorted(by: { $0.compare($1) == .orderedAscending })
            if sortedResults.isEmpty == false {
                options.insert(sortedResults, at: 0)
            }
            
            // Reload the table view with the loaded categories.
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
            
            // Determine the initially selected index.
            if let initialSelection = initialSelection,
                let index = sortedResults.index(of: initialSelection) {
                selectedIndexPath = IndexPath(row: index, section: 0)
            } else {
                selectedIndexPath = IndexPath(row: 0, section: options.count - 2)
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
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        switch (indexPath.section, indexPath.row) {
        case (options.count - 1, options[options.count - 1].count - 1):
            let addIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            addIcon.image = UIImage.template(named: "cellAccessoryAdd")
            cell.accessoryView = addIcon
            cell.textLabel?.textColor = UIControl(frame: .zero).tintColor
        default:
            cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        }
        cell.textLabel?.text = options[indexPath.section][indexPath.row] ?? DefaultClassifier.category.pickerName
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case options.count - 1:
            ()
        
        default:
            let oldIndexPath = selectedIndexPath!
            selectedIndexPath = indexPath
            tableView.reloadRows(at: [oldIndexPath, indexPath], with: .automatic)
            didSelect?(options[indexPath.section][indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
}
