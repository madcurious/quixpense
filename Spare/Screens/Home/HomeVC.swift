//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

private let kViewID = "kViewID"

private let kTopBottomInset = CGFloat(0)
private let kLeftRightInset = CGFloat(20)
private let kItemSpacing = CGFloat(8)

class HomeVC: MDStatefulViewController {
    
    var collectionView = MDPagedCollectionView()
    let currentDate = NSDate()
    var isCreatingSummaries = false
    
    var summaries = [Summary]()
    
    let forwardButton: CustomBarButton = {
        let forwardButton = CustomBarButton(attributedText: NSAttributedString(string: Icon.Forward.rawValue,
            attributes: [
                NSForegroundColorAttributeName : Color.HomeBarButtonItemDefault,
                NSFontAttributeName : Font.icon(26)
            ]))
        return forwardButton
    }()
    
    override var primaryView: UIView {
        return self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.collectionView.backgroundColor = Color.HomeScreenBackgroundColor
        self.collectionView.registerCellNib(__HVCCell.nib(), withReuseIdentifier: kViewID)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
        
        self.forwardButton.addTarget(self, action: #selector(handleTapOnForwardButton), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.forwardButton)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(handleUpdatesOnDataStore), name: NSManagedObjectContextDidSaveNotification, object: App.state.mainQueueContext)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationBar = self.navigationController?.navigationBar {
            let colorImage = UIImage.imageFromColor(Color.HomeScreenBackgroundColor)
            navigationBar.shadowImage = colorImage
            navigationBar.setBackgroundImage(colorImage, forBarMetrics: .Default)
        }
    }
    
    func handleUpdatesOnDataStore() {
        self.collectionView.reloadData()
    }
    
    override func buildOperation() -> MDOperation? {
        return
            CreateSummariesOperation(baseDate: self.currentDate, periodization: .Day, count: 10, precount: self.numberOfItemsInCollectionView(self.collectionView))
                .onStart({[unowned self] in
                    self.isCreatingSummaries = true
                    })
                .onReturn({[unowned self] in
                    self.isCreatingSummaries = false
                    })
                
                .onSuccess({[unowned self] result in
                    guard let newSummaries = result as? [Summary]
                        else {
                            return
                    }
                    
                    self.summaries.insertContentsOf(newSummaries, at: 0)
                    self.collectionView.reloadData()
                    
                    if self.currentView != .Primary {
                        self.scrollToLastItem()
                        self.showView(.Primary)
                    }
                    
                    })
    }
    
    
    
    func handleTapOnForwardButton() {
        self.scrollToLastItem()
    }
    
    func scrollToLastItem() {
        self.collectionView.scrollToLastItem(animated: true, completion: {[unowned self] in
            self.forwardButton.enabled = false
            })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

// MARK: - MDPagedCollectionViewDataSource
extension HomeVC: MDPagedCollectionViewDataSource {
    
    func numberOfItemsInCollectionView(collectionView: MDPagedCollectionView) -> Int {
        return self.summaries.count
    }
    
    func collectionView(collectionView: MDPagedCollectionView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndex: index) as? __HVCCell
            else {
                fatalError()
        }
        cell.summary = self.summaries[index]
        
        return cell
    }
    
}

// MARK: - MDPagedCollectionViewDelegate
extension HomeVC: MDPagedCollectionViewDelegate {
    
    // MARK: Layout
    
    func collectionView(collectionView: MDPagedCollectionView, sizeForItemAtIndex index: Int) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        size.height = size.height - (kTopBottomInset * 2)
        return size
    }
    
    func insetsForCollectionView(collectionView: MDPagedCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: kTopBottomInset, left: kLeftRightInset, bottom: kTopBottomInset, right: kLeftRightInset)
    }
    
    func minimumInterItemSpacingForCollectionView(collectionView: MDPagedCollectionView) -> CGFloat {
        return kItemSpacing
    }
    
    // MARK: Events
    
    func collectionViewDidScroll(collectionView: MDPagedCollectionView, page: CGFloat) {
        // Create summary objects if scrolling near the end.
        if let operation = self.buildOperation()
            where page <= 5 && self.isCreatingSummaries == false {
            self.operationQueue.addOperation(operation)
        }
    }
    
    func collectionViewDidEndDecelerating(collectionView: MDPagedCollectionView, page: CGFloat) {
        // Enable/disable the forward button depending on the scroll offset.
        self.forwardButton.enabled = page < CGFloat(self.summaries.count - 1)
    }
    
}
