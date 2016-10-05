//
//  DatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private enum ViewID: String {
    case PageCell = "PageCell"
}

private enum PageDirection {
    case previous, next
}

protocol DatePickerVCDelegate {
    func datePickerDidSelectDate(_ date: Date)
}

class DatePickerVC: UIViewController {
    
//    static let selectedDateFormatter: NSDateFormatter = {
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "EEE, d MMM yyyy"
//        return formatter
//    }()
    
    static let monthLabelFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    let customView = __DPVCView.instantiateFromNib() as __DPVCView
    let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 10])
    
    var months = [Date]()
    let dayCountCache = NSCache()
    let fillerCountCache = NSCache()
    
    var selectedDate: Date
    var delegate: DatePickerVCDelegate?
    var shouldUpdateDelegate = false
    
    init(selectedDate: Date, delegate: DatePickerVCDelegate?) {
        self.selectedDate = selectedDate
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        self.embedChildViewController(self.pageVC, toView: self.customView.pageVCContainer)
        
        // Add the current month to the data source.
        let currentMonth = self.firstDayOfMonthInDate(self.selectedDate)
        let previousMonths = self.generateMoreMonths(.previous, baseDate: self.selectedDate)
        self.months.append(contentsOf: previousMonths)
        self.months.append(currentMonth)
        let nextMonths = self.generateMoreMonths(.next, baseDate: self.selectedDate)
        self.months.append(contentsOf: nextMonths)
        
        // Add the current month to the page VC.
        let initialPage = MonthPageVC(month: currentMonth, globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([initialPage], direction: .forward, animated: false, completion: nil)
        
        // Initially select the current month.
        self.customView.selectedDateLabel.text = DateFormatter.displayTextForExpenseEditorDate(self.selectedDate)
        self.customView.monthLabel.text = DatePickerVC.monthLabelFormatter.string(from: currentMonth)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
        
        self.customView.previousButton.addTarget(self, action: #selector(handleTapOnPreviousButton), for: .touchUpInside)
        self.customView.nextButton.addTarget(self, action: #selector(handleTapOnNextButton), for: .touchUpInside)
        
        // Listen to date selections in month pages.
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateSelectionNotification(_:)), name: NSNotificationName.monthPageVCDidSelectDate.string(), object: nil)
    }
    
//    private func generateMonthsFromDate(date: NSDate, forPageDirection pageDirection: PageDirection) -> [NSDate] {
//        // Use the first day of the month as the base date.
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
//        components.day = 1
//        let baseMonth = calendar.dateFromComponents(components)!
//        
//        var months = [NSDate]()
//        for i in 1 ... 6 {
//            let increment = pageDirection == .Previous ? -(i) : i
//            let newMonth = calendar.dateByAddingUnit(.Month, value: increment, toDate: baseMonth, options: [])!
//            let insertionIndex = pageDirection == .Previous ? 0 : months.count
//            months.insert(newMonth, atIndex: insertionIndex)
//        }
//        
//        return months
//    }
    
    fileprivate func generateMoreMonths(_ direction: PageDirection, baseDate: Date? = nil) -> [Date] {
        var baseDate: Date = {
            if let baseDate = baseDate {
                return baseDate
            }
            let edgeDate = direction == .next ? self.months.last! : self.months.first!
            return edgeDate
        }()
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.month, .day, .year], from: baseDate)
        components.day = 1
        baseDate = calendar.date(from: components)!
        
        var months = [Date]()
        for i in 1 ... 6 {
            let increment = direction == .previous ? -(i) : i
            let newMonth = (calendar as NSCalendar).date(byAdding: .month, value: increment, to: baseDate, options: [])!
            let insertionIndex = direction == .previous ? 0 : months.count
            months.insert(newMonth, at: insertionIndex)
        }
        
        return months
    }
    
    func firstDayOfMonthInDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.month, .day, .year], from: date)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    func updateMonthLabelForDate(_ date: Date) {
        self.customView.monthLabel.text = DatePickerVC.monthLabelFormatter.string(from: date)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions
extension DatePickerVC {
    
    func handleTapOnDimView() {
        if let delegate = self.delegate
            , self.shouldUpdateDelegate == true {
            delegate.datePickerDidSelectDate(self.selectedDate)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnPreviousButton() {
        let currentPage = self.pageVC.viewControllers!.first as! MonthPageVC
        let indexOfMonth = self.months.index(of: currentPage.month)!
        let previousPage = MonthPageVC(month: self.months[indexOfMonth - 1], globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([previousPage], direction: .reverse, animated: false, completion: nil)
        self.updateMonthLabelForDate(previousPage.month)
        
        if indexOfMonth == 1 {
            let moreMonths = self.generateMoreMonths(.previous)
            self.months.insert(contentsOf: moreMonths, at: 0)
        }
    }
    
    func handleTapOnNextButton() {
        let currentPage = self.pageVC.viewControllers!.first as! MonthPageVC
        let indexOfMonth = self.months.index(of: currentPage.month)!
        let nextPage = MonthPageVC(month: self.months[indexOfMonth + 1], globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([nextPage], direction: .forward, animated: false, completion: nil)
        self.updateMonthLabelForDate(nextPage.month)
        
        if indexOfMonth == self.months.count - 2 {
            let moreMonths = self.generateMoreMonths(.next)
            self.months.append(contentsOf: moreMonths)
        }
    }
    
    func handleDateSelectionNotification(_ notification: Notification) {
        guard let selectedDate = (notification as NSNotification).userInfo?["selectedDate"] as? Date
            , notification.name == NSNotificationName.monthPageVCDidSelectDate.string()
            else {
                return
        }
        
        self.selectedDate = selectedDate
        self.customView.selectedDateLabel.text = DateFormatter.displayTextForExpenseEditorDate(self.selectedDate)
        self.shouldUpdateDelegate = true
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension DatePickerVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MonthPageVC
        let index = self.months.index(of: page.month)!
        
        var previousIndex: Int
        if index == 0 {
            // Generate more pages if needed.
            let moreMonths = self.generateMoreMonths(.previous)
            self.months.insert(contentsOf: moreMonths, at: 0)
            
            previousIndex = moreMonths.count - 1
        } else {
            previousIndex = index - 1
        }
        
        let previousPage = MonthPageVC(month: self.months[previousIndex], globallySelectedDate: self.selectedDate)
        return previousPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MonthPageVC
        let currentIndex = self.months.index(of: page.month)!
        
        if currentIndex == self.months.count - 1 {
            let moreMonths = self.generateMoreMonths(.next)
            self.months.append(contentsOf: moreMonths)
        }
        
        let nextPage = MonthPageVC(month: self.months[currentIndex + 1], globallySelectedDate: self.selectedDate)
        return nextPage
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension DatePickerVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let nextPage = pendingViewControllers.first as? MonthPageVC {
            self.updateMonthLabelForDate(nextPage.month)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = self.pageVC.viewControllers?.first as? MonthPageVC {
            self.updateMonthLabelForDate(currentPage.month)
        }
    }
    
}
