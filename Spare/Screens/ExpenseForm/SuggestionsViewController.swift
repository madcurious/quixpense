//
//  SuggestionsViewController.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

private enum ViewID: String {
    case resultCell = "resultCell"
}

class SuggestionsViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let loadableView = LoadableView()
    let operationQueue = OperationQueue()
    var results = [NSManagedObject]()
    
    override func loadView() {
        self.loadableView.dataViewContainer.addSubviewsAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .groupTableViewBackground
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func fetchSuggestions(for query: String?, classifierType: ClassifierType) {
        let fetchOperation = FetchSuggestionsOperation(query: query, classifierType: classifierType)
        fetchOperation.successBlock = {[unowned self] results in
            self.results = results
            self.tableView.reloadData()
            self.loadableView.state = .data
        }
        fetchOperation.failureBlock = {[unowned self] error in
            self.loadableView.state = .error(error)
        }
        
        self.loadableView.state = .loading
        self.operationQueue.cancelAllOperations()
        self.operationQueue.addOperation(fetchOperation)
    }
    
}

// MARK: - UITableViewDataSource

extension SuggestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let existingCell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.resultCell.rawValue) {
            cell = existingCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: ViewID.resultCell.rawValue)
            cell.backgroundColor = .groupTableViewBackground
        }
        
        cell.textLabel?.text = self.results[indexPath.row].value(forKey: "name") as? String
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SuggestionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

extension SuggestionsViewController {
    
    class func present(from presenter: ExpenseFormViewController, keyboardBounds: CGRect) {
        let modal = SuggestionsViewController()
        
        let transitioningDelegate = kTransitioningDelegate
        transitioningDelegate.keyboardBounds = keyboardBounds
        transitioningDelegate.presentingFormView = presenter.customView
        
        modal.setCustomTransitioningDelegate(transitioningDelegate)
        presenter.present(modal, animated: true, completion: nil)
    }
    
}

fileprivate let kTransitioningDelegate = SuggestionsViewControllerTransitioningDelegate()

fileprivate class SuggestionsViewControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var keyboardBounds = CGRect.zero
    var presentingFormView = ExpenseFormView()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SuggestionsPresentationController(keyboardBounds: self.keyboardBounds, presentingFormView: self.presentingFormView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SuggestionsDismissalController()
    }
    
}

fileprivate class SuggestionsPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var keyboardBounds: CGRect
    var presentingFormView: ExpenseFormView
    
    init(keyboardBounds: CGRect, presentingFormView: ExpenseFormView) {
        self.keyboardBounds = keyboardBounds
        self.presentingFormView = presentingFormView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromView = transitionContext.view(forKey: .from) as? ExpenseFormView
//            else {
//                return
//        }
        let containerView = transitionContext.containerView
        
        let listHeight = CGFloat(44 * 2)
        let minimumY = self.keyboardBounds.size.height - listHeight
        
        let scrollViewOffset: CGPoint = {
            let lowerLeftCorner: CGPoint = {
                var corner = self.presentingFormView.categoryFieldView.frame.origin
                corner.y += self.presentingFormView.categoryFieldView.bounds.size.height
                corner = UIApplication.shared.keyWindow!.convert(corner, from: self.presentingFormView.categoryFieldView)
                return corner
            }()
            
            if lowerLeftCorner.y > minimumY {
                // The field appears below the suggestion list so take the deficit into account in the offset.
                return CGPoint(x: 0, y: lowerLeftCorner.y - minimumY)
            } else {
                return .zero
            }
        }()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        self.presentingFormView.scrollView.contentOffset = scrollViewOffset
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })
    }
}

fileprivate class SuggestionsDismissalController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) as? ExpenseFormView
            else {
                return
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        toView.scrollView.contentOffset = .zero
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
