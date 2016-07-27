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

class HomeVC2: MDStatefulViewController {
    
    let pageViewController: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey : 20
            ])
        pager.setViewControllers([UIViewController()], direction: .Forward, animated: false, completion: nil)
        return pager
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
        return self.pageViewController.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
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
//            let colorImage = UIImage.imageFromColor(Color.NavigationBarBackgroundColor)
//            navigationBar.shadowImage = colorImage
//            navigationBar.setBackgroundImage(colorImage, forBarMetrics: .Default)
            navigationBar.barTintColor = Color.NavigationBarBackgroundColor
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
                
                self.summaries.insertContentsOf(newSummaries, at: 0)
                
                if self.currentView != .Primary {
                    self.scrollToLastSummary(animated: false)
                    self.showView(.Primary)
                }
                
                })
    }
    
    func scrollToLastSummary(animated animated: Bool) {
        guard let lastSummary = self.summaries.last
            else {
                return
        }
        self.pageViewController.setViewControllers([SummaryVC2(summary: lastSummary)], direction: .Forward, animated: animated, completion: nil)
    }
    
    func handleUpdatesOnDataStore() {
        guard let summaryVC = self.pageViewController.viewControllers?.first as? SummaryVC2
            else {
                return
        }
        summaryVC.reloadData()
    }
    
    func handleTapOnForwardButton() {
        if let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC2,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            where currentIndex == self.summaries.count - 1 {
            return
        }
        
        self.scrollToLastSummary(animated: true)
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

extension HomeVC2: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC2,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            else {
                return nil
        }
        
        let previousIndex = currentIndex - 1
        if previousIndex > 0 {
            // Start another create operation if nearing the end.
            if let op = self.buildOperation()
                where previousIndex == 5 {
                self.operationQueue.addOperation(op)
            }
            
            let previousPage = SummaryVC2(summary: self.summaries[previousIndex])
            return previousPage
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC2,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            else {
                return nil
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < self.summaries.count {
            let previousPage = SummaryVC2(summary: self.summaries[nextIndex])
            return previousPage
        }
        return nil
    }
    
}

extension HomeVC2: UIPageViewControllerDelegate {
    
    
    
}

