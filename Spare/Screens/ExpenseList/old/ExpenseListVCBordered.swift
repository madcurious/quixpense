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
    let startDate: Date
    let endDate: Date
    
    let headerView = ExpenseListHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
    let customView = __ELVCBView.instantiateFromNib() as __ELVCBView
    
    var expenses: [Expense]? {
        return glb_autoreport({[unowned self] in
            let request = NSFetchRequest(entityName: Expense.entityName)
            request.predicate = NSPredicate(format: "category == %@ && dateSpent >= %@ && dateSpent <= %@", self.category, self.startDate, self.endDate)
            if let expenses = try App.mainQueueContext.executeFetchRequest(request) as? [Expense]
                , expenses.count > 0 {
                return expenses
            }
            return nil
            })
    }
    
    init(category: Category, startDate: Date, endDate: Date) {
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
        self.customView.tableView.register(__ELVCBCell.nib(), forCellReuseIdentifier: ViewID.Cell.rawValue)
        self.customView.tableView.register(__ELVCBEmptyCell.self, forCellReuseIdentifier: ViewID.EmptyCell.rawValue)
        
        if let navigationBar = self.navigationController?.navigationBar {
            let colorImage = UIImage.imageFromColor(self.category.color)
            navigationBar.shadowImage = colorImage
            navigationBar.setBackgroundImage(colorImage, for: .default)
            navigationBar.tintColor = UIColor.white
        }
        
        let addButton = Button(string: Icon.ThinAddSign.rawValue, font: Font.icon(30), textColor: Color.UniversalTextColor)
        addButton.addTarget(self, action: #selector(handleTapOnAddExpenseButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    func setupHeaderView() {
        guard let categoryName = self.category.name
            else {
                return
        }
        
        self.customView.colorExtender.backgroundColor = category.color
        self.headerView.backgroundColor = category.color
        self.headerView.nameLabel.text = categoryName
        let dateRangeText = DateFormatter.displayTextForStartDate(self.startDate, endDate: self.endDate)
        let totalText = AmountFormatter.displayTextForAmount({[unowned self] in
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
        self.present(BaseNavBarVC(rootViewController: AddExpenseVC(preselectedCategory: self.category, preselectedDate: self.startDate)),
                                   animated: true, completion: nil)
    }
    
    func handleSaveOnManagedObjectContext() {
        // Refetch category.
        if let category = App.mainQueueContext.object(with: self.category.objectID) as? Category {
            self.category = category
        }
        self.setupHeaderView()
        self.customView.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let expenses = self.expenses
            else {
                // Make way for the empty view.
                self.customView.tableView.separatorStyle = .none
                return 1
        }
        self.customView.tableView.separatorStyle = .singleLine
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let expenses = self.expenses {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.Cell.rawValue) as? __ELVCBCell
                else {
                    fatalError()
            }
            cell.data = (expenses[(indexPath as NSIndexPath).row], App.state.selectedPeriodization)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.EmptyCell.rawValue, for: indexPath)
            return cell
        }
    }
    
}

extension ExpenseListVCBordered: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.expenses == nil {
            // Return height for empty view.
            return max(0, tableView.bounds.size.height - self.headerView.bounds.size.height)
        }
        return 50
    }
    
}

// MARK: - UIScrollViewDelegate
extension ExpenseListVCBordered: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let colorExtenderHeight: CGFloat = {
            if self.customView.tableView.contentOffset.y > 0 {
                return 0
            }
            return abs(self.customView.tableView.contentOffset.y)
        }()
        self.customView.colorExtenderHeight.constant = colorExtenderHeight
    }
    
}
