//
//  FilterButton.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class FilterButton: MDButton, Themeable {
    
    @IBOutlet weak var roundedRectView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var filter = Global.filter {
        didSet {
            self.filterLabel.text = self.filter.text()
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.roundedRectView.isUserInteractionEnabled = false
        self.filterLabel.isUserInteractionEnabled = false
        self.arrowImageView.isUserInteractionEnabled = false
        
        self.filterLabel.font = Global.theme.font(for: .filterButtonText)
        self.filterLabel.numberOfLines = 1
        self.filterLabel.lineBreakMode = .byTruncatingMiddle
        self.filterLabel.text = self.filter.text()
        self.filterLabel.textAlignment = .center
        
        self.arrowImageView.image = UIImage.templateNamed("filterButtonArrow")
        
        self.applyTheme()
        
        self.addTarget(self, action: #selector(handleTapOnSelf), for: .touchUpInside)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: self.filterLabel.sizeThatFits(size).width + self.arrowImageView.sizeThatFits(size).width, height: 44)
    }
    
    func applyTheme() {
        self.roundedRectView.backgroundColor = Global.theme.color(for: .filterButtonBackground)
        self.filterLabel.textColor = Global.theme.color(for: .filterButtonContent)
        self.arrowImageView.tintColor = Global.theme.color(for: .filterButtonContent)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundedRectView.layer.cornerRadius = self.roundedRectView.bounds.size.height / 2
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

