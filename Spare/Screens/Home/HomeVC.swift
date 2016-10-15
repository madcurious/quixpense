//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class HomeVC: MDOperationViewController {
    
    let pageViewController: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey : 20
            ])
        pager.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        return pager
    }()
    
    let currentDate = Date()
    var isCreatingSummaries = false
    var summaries = [Summary]()
    
    let forwardButton = Button(string: "Now", font: Font.ModalBarButtonText, textColor: Color.UniversalTextColor)
    let periodizationButton = PeriodizationButton()
    let customLoadingView = OperationVCLoadingView()
    
    override var primaryView: UIView {
        return self.pageViewController.view
    }
    
    override var loadingView: UIView {
        return self.customLoadingView
    }
    
    override init() {
        super.init()
        self.title = "Spare"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .bottom
        
        self.pageViewController.view.backgroundColor = Color.UniversalBackgroundColor
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.showView(.loading)
        
        self.noResultsView.backgroundColor = Color.UniversalBackgroundColor
        
        self.periodizationButton.addTarget(self, action: #selector(handleSelectionOfPeriodization), for: .valueChanged)
        self.forwardButton.addTarget(self, action: #selector(handleTapOnForwardButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.periodizationButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.forwardButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleUpdatesOnDataStore), name: NSNotification.Name.NSManagedObjectContextDidSave, object: App.mainQueueContext)
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
                
                self.summaries.insert(contentsOf: newSummaries, at: 0)
                
                if self.currentView != .primary {
                    self.scrollToLastSummary(animated: false)
                    self.showView(.primary)
                }
                
                })
    }
    
    func scrollToLastSummary(animated: Bool) {
        guard let lastSummary = self.summaries.last
            else {
                return
        }
        self.pageViewController.setViewControllers([SummaryVC(summary: lastSummary)], direction: .forward, animated: animated, completion: nil)
    }
    
    func handleUpdatesOnDataStore() {
        guard let summaryVC = self.pageViewController.viewControllers?.first as? SummaryVC
            else {
                return
        }
        summaryVC.collectionView.reloadData()
    }
    
    func handleTapOnForwardButton() {
        if let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.index(of: currentPage.summary)
            , currentIndex == self.summaries.count - 1 {
            return
        }
        
        self.scrollToLastSummary(animated: true)
    }
    
    func handleSelectionOfPeriodization() {
        App.state.selectedPeriodization = self.periodizationButton.selectedPeriodization
        self.summaries = []
        self.runOperation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension HomeVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.index(of: currentPage.summary)
            else {
                return nil
        }
        
        let previousIndex = currentIndex - 1
        if previousIndex > 0 {
            // Start another create operation if nearing the end.
            if let op = self.buildOperation()
                , previousIndex == 5 {
                self.operationQueue.addOperation(op)
            }
            
            let previousPage = SummaryVC(summary: self.summaries[previousIndex])
            return previousPage
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.index(of: currentPage.summary)
            else {
                return nil
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < self.summaries.count {
            let previousPage = SummaryVC(summary: self.summaries[nextIndex])
            return previousPage
        }
        return nil
    }
    
}

extension HomeVC: UIPageViewControllerDelegate {
    
    
    
}

