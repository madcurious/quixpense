//
//  ExpenseListGroupCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

private let kRowHeight = CGFloat(44)
private let kSeparatorHeight = CGFloat(0.5)

private enum ViewID: String {
    case expenseCell = "ExpenseCell"
}

class ExpenseListGroupCell: UICollectionViewCell, Themeable {
    
    @IBOutlet weak var groupBackgroundView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var stemView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    class func expandedHeight(for group: DayCategoryGroup) -> CGFloat {
        let expenseCount = CGFloat(group.expenses?.count ?? 0)
        return kRowHeight +
            (expenseCount * kRowHeight) +
            ((expenseCount - 1) * kSeparatorHeight)
    }
    
    weak var categoryGroup: DayCategoryGroup? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            if let categoryGroup = self.categoryGroup {
                self.groupLabel.text = categoryGroup.category?.name
                self.totalLabel.text = AmountFormatter.displayText(for: categoryGroup.total)
                
                guard let expenses = categoryGroup.expenses?.allObjects as? [Expense],
                    expenses.count > 0
                    else {
                        self.orderedExpenses = []
                        self.collectionViewHeight.constant = 0
                        return
                }
                
                self.orderedExpenses = expenses.sorted(by: {
                    guard let date1 = $0.dateCreated as Date?,
                        let date2 = $1.dateCreated as Date?
                        else {
                            return false
                    }
                    return date1.compare(date2) == .orderedDescending
                })
                
                let expenseCount = CGFloat(expenses.count)
                self.collectionViewHeight.constant = (expenseCount * kRowHeight) + ((expenseCount - 1) * kSeparatorHeight)
            } else {
                self.arrowImageView.image = nil
                self.groupLabel.text = nil
                self.totalLabel.text = nil
                self.orderedExpenses = []
            }
        }
    }
    
    var orderedExpenses = [Expense]()
    
    var isExpanded = false {
        didSet {
            if self.isExpanded {
                self.collectionView.reloadData()
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.applyHighlight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        
        self.collectionViewContainer.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        
        self.collectionView.isScrollEnabled = false
        self.collectionView.register(ExpenseListExpenseCell.nib(), forCellWithReuseIdentifier: ViewID.expenseCell.rawValue)
        self.collectionView.clipsToBounds = true
        
        self.applyTheme()
        self.applyHighlight()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func applyTheme() {
        self.backgroundColor = Global.theme.color(for: .mainBackground)
        self.stemView.backgroundColor = Global.theme.color(for: .expenseListStemView)
        
        self.groupLabel.font = Global.theme.font(for: .regularText)
        self.totalLabel.font = Global.theme.font(for: .regularText)
        
        self.groupLabel.textColor = Global.theme.color(for: .regularText)
        self.totalLabel.textColor = Global.theme.color(for: .regularText)
    }
    
    func applyHighlight() {
        if self.isHighlighted {
            self.groupBackgroundView.backgroundColor = Global.theme.color(for: .expenseListGroupCellBackgroundHighlighted)
        } else {
            self.groupBackgroundView.backgroundColor = Global.theme.color(for: .expenseListGroupCellBackgroundDefault)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension ExpenseListGroupCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryGroup?.expenses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.expenseCell.rawValue, for: indexPath) as! ExpenseListExpenseCell
        cell.expense = self.orderedExpenses[indexPath.item]
        return cell
    }
    
}

extension ExpenseListGroupCell: UICollectionViewDelegate {
    
}

extension ExpenseListGroupCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: kRowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kSeparatorHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kSeparatorHeight
    }
    
}
