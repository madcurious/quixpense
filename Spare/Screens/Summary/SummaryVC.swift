//
//  SummaryVC.swift
//  Spare
//
//  Created by Matt Quiros on 27/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case Graph = "Graph"
    case Cell = "Cell"
}

private let kCellInset = CGFloat(10)

private enum View {
    case chart, zero
}

class SummaryVC: UIViewController {
    
    var summary: Summary {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layoutManager = UICollectionViewFlowLayout()
        layoutManager.scrollDirection = .vertical
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutManager)
    }()
    
    lazy var zeroView = __SVCZeroView.instantiateFromNib()
    
    init(summary: Summary) {
        self.summary = summary
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let mainView = UIView()
        mainView.addSubviewsAndFill(self.zeroView, self.collectionView)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadView()
        
        let system = NotificationCenter.default
        system.addObserver(self, selector: #selector(handlePerformedExpenseOperation(_:)),
                           name: Notifications.PerformedExpenseOperation, object: nil)
    }
    
    func reloadView() {
        if self.summary.total == NSDecimalNumber(value: 0 as Int) {
            self.showView(.zero)
        } else {
            self.showView(.chart)
        }
    }
    
    func setupCollectionView() {
        self.collectionView.backgroundView = UIImageView(image: UIImage.imageFromColor(Color.UniversalBackgroundColor))
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.register(__SVCGraphView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Graph.rawValue)
        self.collectionView.register(__SVCCategoryCellBox.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func setupZeroView() {
        self.zeroView.dateLabel.text = DateFormatter.displayTextForSummary(self.summary)
    }
    
    fileprivate func showView(_ view: View) {
        self.zeroView.isHidden = view != .zero
        self.collectionView.isHidden = view != .chart
        
        switch view {
        case .chart:
            self.setupCollectionView()
            
        case .zero:
            self.setupZeroView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Target actions
extension SummaryVC {
    
    func handlePerformedExpenseOperation(_ notification: Notification) {
        guard let expenseObject = notification.object as? Expense,
            let expense = App.mainQueueContext.object(with: expenseObject.objectID) as? Expense
            else {
                return
        }
        
        if self.summary.containsDate(expense.dateSpent! as Date) {
            self.reloadView()
        }
    }
    
}

extension SummaryVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return App.allCategories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.Cell.rawValue, for: indexPath) as? __SVCCategoryCell
            else {
                fatalError()
        }
        cell.data = self.summary.data?[(indexPath as NSIndexPath).item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let graphView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewID.Graph.rawValue, for: indexPath) as? __SVCGraphView
            , kind == UICollectionElementKindSectionHeader
            else {
                fatalError()
        }
        graphView.summary = self.summary
        return graphView
    }
    
}

extension SummaryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = self.summary.data?[(indexPath as NSIndexPath).item].0
            else {
                return
        }
        
        // Notify the container that a category cell has been tapped.
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(
            name: Notification.Name(rawValue: Event.CategoryTappedInSummaryVC.rawValue),
            object: nil,
            userInfo: [
                "category" : category,
                "startDate" : self.summary.startDate,
                "endDate" : self.summary.endDate
            ])
    }
    
}

extension SummaryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.size.width - kCellInset * 2
        let dynamicHeight = __SVCCategoryCellBox.cellHeightForData(self.summary.data![(indexPath as NSIndexPath).item], cellWidth: cellWidth)
        return CGSize(width: cellWidth, height: dynamicHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, kCellInset, kCellInset, kCellInset)
    }
    
}

