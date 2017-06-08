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
    
    // MARK: - Target actions
    
    func handleTapOnSelf() {
        let filterPopup = FilterPopupViewController(filter: self.filter, delegate: self)
        let modal = BaseNavBarVC(rootViewController: filterPopup)
        modal.modalPresentationStyle = .popover
        
        guard let popoverController = modal.popoverPresentationController,
            let parent = UIApplication.shared.keyWindow?.rootViewController
            else {
                return
        }
        popoverController.delegate = self
        popoverController.sourceView = self
        popoverController.sourceRect = self.bounds
        popoverController.permittedArrowDirections = [.up]
        let filterPopupViewSize = filterPopup.customView.sizeThatFits(CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude))
        modal.preferredContentSize = CGSize(width: 300,
                                            height: filterPopupViewSize.height)
        
        parent.present(modal, animated: true, completion: nil)
    }
    
}

extension FilterButton: FilterPopupViewControllerDelegate {
    
    func filterPopupViewController(_ viewController: FilterPopupViewController, didSelect filter: Filter) {
        if filter != self.filter {
            self.filter = filter
            self.sendActions(for: .valueChanged)
        }
    }
    
}

extension FilterButton: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

