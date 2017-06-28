//
//  SuggestionsViewController.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

private enum ViewID: String {
    case resultCell = "resultCell"
}

class SuggestionsViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let loadableView = LoadableView()
    let operationQueue = OperationQueue()
    var results = [NSManagedObject]()
    
    override func loadView() {
        self.loadableView.dataViewContainer.addSubviewsAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func fetchSuggestions(for query: String?, classifierType: ClassifierType) {
        let fetchOperation = FetchSuggestionsOperation(query: query, classifierType: classifierType)
        fetchOperation.successBlock = {[unowned self] results in
            self.results = results
            self.tableView.reloadData()
            self.loadableView.state = .data
        }
        fetchOperation.failureBlock = {[unowned self] error in
            self.loadableView.state = .error(error)
        }
        
        self.loadableView.state = .loading
        self.operationQueue.cancelAllOperations()
        self.operationQueue.addOperation(fetchOperation)
    }
    
}

// MARK: - UITableViewDataSource

extension SuggestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let existingCell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.resultCell.rawValue) {
            cell = existingCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: ViewID.resultCell.rawValue)
        }
        
        cell.textLabel?.text = self.results[indexPath.row].value(forKey: "name") as? String
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SuggestionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
