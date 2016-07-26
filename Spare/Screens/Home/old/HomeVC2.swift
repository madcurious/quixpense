//
//  HomeVC2.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

private enum ViewID: String {
    case Cell = "Cell"
}

class HomeVC2: MDStatefulViewController {
    
    var collectionView: UICollectionView = {
        let layoutManager = UICollectionViewFlowLayout()
        layoutManager.scrollDirection = .Horizontal
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layoutManager)
        collectionView.pagingEnabled = true
        return collectionView
    }()
    
    let currentDate = NSDate()
    var isCreatingSummaries = false
    var summaries = [Summary]()
    
    let forwardButton: CustomButton = {
        let forwardButton = CustomButton(attributedText: NSAttributedString(string: Icon.Forward.rawValue,
            attributes: [
                NSForegroundColorAttributeName : Color.HomeBarButtonItemDefault,
                NSFontAttributeName : Font.icon(26)
            ]))
        return forwardButton
    }()
    
    let periodizationButton: CustomButton = {
        let periodizationButton = CustomButton(attributedText:
            NSAttributedString(string: App.state.selectedPeriodization.descriptiveText,
                attributes: [
                    NSForegroundColorAttributeName : Color.HomeBarButtonItemDefault,
                    NSFontAttributeName : Font.HomeBarButtonItem
                ]))
        return periodizationButton
    }()
    
    override var primaryView: UIView {
        return self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.collectionView.backgroundColor = Color.HomeScreenBackgroundColor
        self.collectionView.registerClass(__HVC2Cell.self, forCellWithReuseIdentifier: ViewID.Cell.rawValue)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
        
        self.periodizationButton.addTarget(self, action: #selector(handleTapOnPeriodizationButton), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = self.periodizationButton
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
    
    override func buildOperation() -> MDOperation? {
        return CreateSummariesOperation(baseDate: self.currentDate,
            periodization: App.state.selectedPeriodization,
            startOfWeek: App.state.selectedStartOfWeek,
            count: 10,
            startingPage: self.summaries.count)
            
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
                
//                let currentIndexPath = self.collectionView.indexPathsForVisibleItems().first
                self.summaries.insertContentsOf(newSummaries, at: 0)
                self.collectionView.reloadData()
                
                if self.currentView != .Primary {
                    self.scrollToLastItem()
                    self.showView(.Primary)
                } else {
                    // Doesn't work :(
                    let count = newSummaries.count
                    let contentWidth = self.collectionView.contentSize.width
                    let offsetX = self.collectionView.contentOffset.x
                    let offsetFromRight = contentWidth - offsetX
                    
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    
                    self.collectionView.performBatchUpdates({[unowned self] in
                        var indexPaths = [NSIndexPath]()
                        for i in 0..<count {
                            indexPaths.append(NSIndexPath(forItem: i, inSection: 0))
                        }
                        self.collectionView.insertItemsAtIndexPaths(indexPaths)
                        }, completion: {[unowned self] (_) in
                            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentSize.width - offsetFromRight, 0)
                            CATransaction.commit()
                    })
                }
                })
    }
    
    func scrollToLastItem() {
//        self.collectionView.scrollToLastItem(animated: true, completion: {[unowned self] in
//            self.forwardButton.enabled = false
//            })
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.summaries.count - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    func handleUpdatesOnDataStore() {
        self.collectionView.reloadData()
    }
    
    func handleTapOnForwardButton() {
        self.scrollToLastItem()
    }
    
    func handleTapOnPeriodizationButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let options: [Periodization] = [.Day, .Week, .Month, .Year]
        for i in 0 ..< options.count {
            let option = options[i]
            let action = UIAlertAction(title: option.descriptiveText, style: .Default, handler: {[unowned self] _ in
                self.handleSelectionOnPeriodization(option)
                })
            actionSheet.addAction(action)
        }
        actionSheet.addCancelAction()
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func handleSelectionOnPeriodization(periodization: Periodization) {
        guard App.state.selectedPeriodization != periodization
            else {
                return
        }
        
        // Update the system-wide periodisation.
        App.state.selectedPeriodization = periodization
        
        self.periodizationButton.setStringForAttributedText(periodization.descriptiveText)
        
        self.summaries = []
        self.runOperation()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension HomeVC2: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.summaries.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell.rawValue, forIndexPath: indexPath) as? __HVC2Cell
            else {
                fatalError()
        }
        cell.summary = self.summaries[indexPath.item]
        
        // Generate new summaries when near the left end.
        if let operation = self.buildOperation()
            where indexPath.item == 5 && self.isCreatingSummaries == false {
            self.operationQueue.addOperation(operation)
        }
        
        return cell
    }
    
}

extension HomeVC2: UICollectionViewDelegate {
    
}

extension HomeVC2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}