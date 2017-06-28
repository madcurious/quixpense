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
    
    enum ClassifierType {
        case category, tag
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let loadableView = LoadableView()
    let operationQueue = OperationQueue()
    var results = [ClassifierManagedObject]()
    
    override func loadView() {
        self.loadableView.dataViewContainer.addSubviewsAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @discardableResult
    func fetchSuggestions<T: ClassifierManagedObject>(for string: String?) -> [T]? {
        let operation = FetchSuggestionsOperation<T>(query: string)
        operation.successBlock = {[unowned self] results in
            self.results = results
            self.tableView.reloadData()
            self.loadableView.state = .data
        }
        
        
        return nil
        
//        func makeSuccessBlock<T: ClassifierManagedObject>() -> ([T]) -> Void {
//            return {[unowned self] results in
//                self.results = results
//                self.tableView.reloadData()
//                self.loadableView.state = .data
//            }
//        }
//
//        let failureBlock = {[unowned self] error in
//            self.loadableView.state = .error(error)
//        }
//
//        func runOperation(_ operation: Operation) {
//            self.operationQueue.cancelAllOperations()
//            self.loadableView.state = .loading
//            self.operationQueue.addOperation(operation)
//        }
//
//        if classifierType == .category {
//            let operation = FetchSuggestionsOperation<Category>(query: string)
//            operation.successBlock = makeSuccessBlock()
//            operation.failureBlock = failureBlock
//            runOperation(operation)
//        } else {
//            let operation = FetchSuggestionsOperation<Tag>(query: string)
//            operation.successBlock = makeSuccessBlock()
//            operation.failureBlock = failureBlock
//            runOperation(operation)
//        }
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
