//
//  NewClassifierViewController.swift
//  Spare
//
//  Created by Matt Quiros on 10/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case textFieldCell = "textFieldCell"
}

class NewClassifierViewController: UITableViewController {
    
    let classifierType: ClassifierType
    
    init(classifierType: ClassifierType) {
        self.classifierType = classifierType
        super.init(style: .grouped)
        
        switch classifierType {
        case .category:
            self.title = "New Category"
        case .tag:
            self.title = "New Tag"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(NewClassifierTextFieldCell.nib(), forCellReuseIdentifier: ViewID.textFieldCell.rawValue)
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension NewClassifierViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.textFieldCell.rawValue, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.classifierType {
        case .category:
            return "Enter a category name:"
            
        case .tag:
            return "Enter a tag name:"
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NewClassifierViewController {
    
    
    
}
