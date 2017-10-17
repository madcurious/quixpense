//
//  FilterButton.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class FilterButton: BRButton, Themeable {
    
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var sizerViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var roundedRectView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var roundedRectViewWidth: NSLayoutConstraint!
    
    var filter = Global.filter {
        didSet {
            self.filterLabel.text = self.filter.text()
            self.setNeedsLayout()
        }
    }
    
    var centerConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.sizerView.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.sizerView.isUserInteractionEnabled = false
        self.roundedRectView.isUserInteractionEnabled = false
        self.filterLabel.isUserInteractionEnabled = false
        self.arrowImageView.isUserInteractionEnabled = false
        
        self.filterLabel.font = Global.theme.font(for: .filterButtonText)
        self.filterLabel.numberOfLines = 1
        self.filterLabel.lineBreakMode = .byTruncatingMiddle
        self.filterLabel.text = self.filter.text()
        self.filterLabel.textAlignment = .center
        
        self.arrowImageView.image = UIImage.template(named: "filterButtonArrow")
        
        self.applyTheme()
        
        self.addTarget(self, action: #selector(handleTapOnSelf), for: .touchUpInside)
    }
    
    func applyTheme() {
        self.roundedRectView.backgroundColor = Global.theme.color(for: .filterButtonBackground)
        self.filterLabel.textColor = Global.theme.color(for: .filterButtonContent)
        self.arrowImageView.tintColor = Global.theme.color(for: .filterButtonContent)
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: self.tappableWidth(), height: size.height)
//    }
    
    override func layoutSubviews() {
        self.sizerViewWidth.constant = self.tappableWidth()
        
        super.layoutSubviews()
        
        self.roundedRectViewWidth.constant = self.roundedRectWidth()
        self.roundedRectView.layer.cornerRadius = self.roundedRectView.bounds.size.height / 2
    }
    
    func roundedRectWidth() -> CGFloat {
        return self.filterLabel.sizeThatFits(.max).width +
        self.arrowImageView.bounds.size.width * 2 +
        4 * 2
    }
    
    func tappableWidth() -> CGFloat {
        return self.roundedRectWidth() + (30 * 2)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // As soon as the filter button is added to the navigation bar, add Autolayout
        // that centers the button horizontally.
        // Need to wrap this in optional binding because iOS may remove the button
        // from the superview during UINavigationController's push animation.
        if let superview = self.superview,
            self.centerConstraint == nil {
            self.centerConstraint = self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0)
            self.centerConstraint?.isActive = true
        }
    }
    
}

// MARK: - Target actions
extension FilterButton {
    
    @objc func handleTapOnSelf() {
        let filterPopup = FilterPopupViewController(filter: self.filter)
        filterPopup.modalPresentationStyle = .popover
        
        guard let popoverController = filterPopup.popoverPresentationController,
            let parent = UIApplication.shared.keyWindow?.rootViewController
            else {
                return
        }
        
        popoverController.delegate = self
        popoverController.sourceView = self
        popoverController.sourceRect = self.bounds
        popoverController.permittedArrowDirections = [.up]
        
        filterPopup.preferredContentSize = {
            let computedSize = filterPopup.customView.sizeThatFits(CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: 300,
                          height: computedSize.height)
        }()
        
        parent.present(filterPopup, animated: true, completion: nil)
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate
extension FilterButton: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        if let filterPopup = popoverPresentationController.presentedViewController as? FilterPopupViewController {
            if filterPopup.filter != self.filter {
                self.filter = filterPopup.filter
                self.sendActions(for: .valueChanged)
            }
        }
        return true
    }
    
}

