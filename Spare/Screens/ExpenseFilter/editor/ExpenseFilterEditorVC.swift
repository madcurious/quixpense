//
//  ExpenseFilterEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 28/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

fileprivate enum ViewID: String {
    case nameCell = "nameCell"
    case parameterCell = "parameterCell"
}

class ExpenseFilterEditorVC: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let context: NSManagedObjectContext
    let filter: ExpenseFilter
    
    init(filterId: NSManagedObjectID?) {
        let context = Global.coreDataStack.newBackgroundContext()
        self.context = context
        
        if let filterId = filterId {
            self.filter = context.object(with: filterId) as! ExpenseFilter
        } else {
            self.filter = ExpenseFilter(context: context)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        if filterId == nil {
            self.navigationItem.title = "NEW FILTER"
        } else {
            self.navigationItem.title = "EDIT FILTER"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.tableView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(.cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(.done, target: self, action: #selector(handleTapOnDoneButton))
        
        self.tableView.register(_EFENameCell.nib(), forCellReuseIdentifier: ViewID.nameCell.rawValue)
        self.tableView.register(_EFEParameterCell.nib(), forCellReuseIdentifier: ViewID.parameterCell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTapOnCancelButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleTapOnDoneButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension ExpenseFilterEditorVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.nameCell.rawValue) as! _EFENameCell
            return cell
            
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.parameterCell.rawValue) as! _EFEParameterCell
            cell.nameLabel.text = {
                switch indexPath.row {
                case 0:
                    return "Date"
                case 1:
                    return "Categories"
                default:
                    return nil
                }
            }()
            
            return cell
        }
    }
    
}

extension ExpenseFilterEditorVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1
            else {
                return
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.row) {
        case 0:
            let datePicker = EFEVCDatePickerVC()
            self.navigationController?.pushViewController(datePicker, animated: true)
            
        case 1:
            let valuePicker = EFEVCValuePickerVC<Category>(title: "CATEGORIES",
                                                           sortDescriptors: [NSSortDescriptor(key: #keyPath(Category.name), ascending: true)],
                                                           selectedIndexPaths: nil,
                                                           delegate: self)
            self.navigationController?.pushViewController(valuePicker, animated: true)
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerLabel = (view as? UITableViewHeaderFooterView)?.textLabel
            else {
                return
        }
        
        headerLabel.font = Global.theme.font(for: .tableViewHeader)
        headerLabel.textColor = Global.theme.color(for: .groupedTableViewSectionHeaderText)
        headerLabel.numberOfLines = 1
        headerLabel.lineBreakMode = .byTruncatingTail
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "NAME"
        case 1:
            return "PARAMETERS"
        default:
            return nil
        }
    }
    
}

extension ExpenseFilterEditorVC: EFEVCValuePickerVCDelegate {
    
    func text(for value: NSManagedObject) -> String? {
        guard let category = value as? Category
            else {
                return nil
        }
        
        return category.name
    }
    
    func didSelect(indexPaths: [IndexPath]) {
        
    }
    
}

extension ExpenseFilterEditorVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
    
}
