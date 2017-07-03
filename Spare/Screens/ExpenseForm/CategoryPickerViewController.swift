//
//  CategoryPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryPickerViewControllerDelegate {
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: Category)
}

fileprivate let kTransitioningDelegate = CategoryPickerTransitioningDelegate()

private enum ViewID: String {
    case itemCell = "itemCell"
}

class CategoryPickerViewController: UIViewController {
    
    let fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: true)]
        return NSFetchedResultsController<Category>(fetchRequest: fetchRequest,
                                                    managedObjectContext: Global.coreDataStack.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
    }()
    
    let customView = CategoryPickerView.instantiateFromNib()
    var delegate: CategoryPickerViewControllerDelegate?
    
    init() {
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
        
        do {
            try self.fetchedResultsController.performFetch()
            
            self.customView.tableView.dataSource = self
            self.customView.tableView.delegate = self
            self.customView.tableView.register(PickerItemCell.nib(), forCellReuseIdentifier: ViewID.itemCell.rawValue)
            self.customView.tableView.rowHeight = UITableViewAutomaticDimension
            self.customView.tableView.estimatedRowHeight = 44
            
            self.customView.tableView.reloadData()
        } catch {}
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CategoryPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.fetchedResultsController.fetchedObjects?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.itemCell.rawValue, for: indexPath) as! PickerItemCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = self.fetchedResultsController.object(at: indexPath).name
        } else {
            cell.nameLabel.text = "Label"
        }
        
        return cell
    }
    
}

extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.categoryPicker(self, didSelectCategory: self.fetchedResultsController.object(at: indexPath))
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Class functions

extension CategoryPickerViewController {
    
    class func present(from presenter: ExpenseFormViewController) {
        let picker = CategoryPickerViewController()
        picker.setCustomTransitioningDelegate(kTransitioningDelegate)
        picker.delegate = presenter
        presenter.present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - Internal classes

fileprivate class CategoryPickerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryPickerPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryPickerDismissalAnimator()
    }
    
}

fileprivate class CategoryPickerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Global.viewControllerTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) as? CategoryPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(toView)
        
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        toView.dimView.alpha = 0.0
        toView.stackViewBottom.constant = -(toView.stackView.bounds.size.height)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        
                        toView.dimView.alpha = 0.4
                        
                        toView.stackViewBottom.constant = 0
                        toView.setNeedsLayout()
                        toView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

fileprivate class CategoryPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Global.viewControllerTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) as? CategoryPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(fromView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        fromView.dimView.alpha = 0
                        
                        fromView.stackViewBottom.constant = -(fromView.stackView.bounds.size.height)
                        fromView.setNeedsLayout()
                        fromView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}
