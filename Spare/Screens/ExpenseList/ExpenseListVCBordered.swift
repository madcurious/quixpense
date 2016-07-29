//
//  ExpenseListVCBordered.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack

private enum ViewID: String {
    case Cell = "Cell"
    case EmptyCell = "EmptyCell"
}

class ExpenseListVCBordered: UIViewController {
    
    var category: Category
    let startDate: NSDate
    let endDate: NSDate
    
    let headerView = ExpenseListHeaderView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 0))
    let customView = __ELVCBView.instantiateFromNib() as __ELVCBView
    
    var expenses: [Expense]? {
        return glb_autoreport({[unowned self] in
            let request = NSFetchRequest(entityName: Expense.entityName)
            request.predicate = NSPredicate(format: "category == %@ && dateSpent >= %@ && dateSpent <= %@", self.category, self.startDate, self.endDate)
            if let expenses = try App.state.mainQueueContext.executeFetchRequest(request) as? [Expense]
                where expenses.count > 0 {
                return expenses
            }
            return nil
            })
    }
    
    init(category: Category, startDate: NSDate, endDate: NSDate) {
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        self.setupHeaderView()
        self.customView.tableView.registerNib(__ELVCBCell.nib(), forCellReuseIdentifier: ViewID.Cell.rawValue)
        self.customView.tableView.registerClass(__ELVCBEmptyCell.self, forCellReuseIdentifier: ViewID.EmptyCell.rawValue)
        
        if let navigationBar = self.navigationController?.navigationBar {
            let colorImage = UIImage.imageFromColor(self.category.color)
            navigationBar.shadowImage = colorImage
            navigationBar.setBackgroundImage(colorImage, forBarMetrics: .Default)
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func setupHeaderView() {
        guard let categoryName = self.category.name
            else {
                return
        }
        
        self.customView.colorExtender.backgroundColor = category.color
        self.headerView.backgroundColor = category.color
        self.headerView.nameLabel.text = categoryName
        let dateRangeText = DateRangeFormatter.displayTextForStartDate(self.startDate, endDate: self.endDate)
        let totalText = glb_displayTextForTotal({[unowned self] in
            if let expenses = self.expenses {
                return glb_totalOfExpenses(expenses)
            }
            return 0
            }())
        self.headerView.detailLabel.text = "\(totalText) \(dateRangeText)"
        
        self.headerView.setNeedsLayout()
        self.headerView.layoutIfNeeded()
        self.customView.tableView.tableHeaderView = self.headerView
    }
    
    func handleTapOnAddExpenseButton() {
        self.presentViewController(BaseNavBarVC(rootViewController: AddExpenseVC(preselectedCategory: self.category, preselectedDate: self.startDate)),
                                   animated: true, completion: nil)
    }
    
    func handleSaveOnManagedObjectContext() {
        // Refetch category.
        if let category = App.state.mainQueueContext.objectWithID(self.category.objectID) as? Category {
            self.category = category
        }
        self.setupHeaderView()
        self.customView.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Fixes that crappy iOS bug where partially dragging from the left side
        // hides the navigation bar.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension ExpenseListVCBordered: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let expenses = self.expenses
            else {
                // Make way for the empty view.
                self.customView.tableView.separatorStyle = .None
                return 1
        }
        self.customView.tableView.separatorStyle = .SingleLine
        return expenses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let expenses = self.expenses {
            guard let cell = tableView.dequeueReusableCellWithIdentifier(ViewID.Cell.rawValue) as? __ELVCBCell
                else {
                    fatalError()
            }
            cell.data = (expenses[indexPath.row], App.state.selectedPeriodization)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(ViewID.EmptyCell.rawValue, forIndexPath: indexPath)
            return cell
        }
    }
    
}

extension ExpenseListVCBordered: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.expenses == nil {
            // Return height for empty view.
            return tableView.bounds.size.height - self.headerView.bounds.size.height
        }
        return 50
    }
    
}

// MARK: - UIScrollViewDelegate
extension ExpenseListVCBordered: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let colorExtenderHeight: CGFloat = {
            if self.customView.tableView.contentOffset.y > 0 {
                return 0
            }
            return abs(self.customView.tableView.contentOffset.y)
        }()
        self.customView.colorExtenderHeight.constant = colorExtenderHeight
    }
    
}
