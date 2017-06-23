//
//  ExpenseFormView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseFormView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var separatorViews: [UIView]!
    
    @IBOutlet weak var amountFieldContainer: UIView!
    let amountFieldView = AmountFieldView.instantiateFromNib()
    
    @IBOutlet weak var dateFieldContainer: UIView!
    let dateFieldView = DateFieldView.instantiateFromNib()
    
    @IBOutlet weak var categoryFieldContainer: UIView!
    @IBOutlet weak var tagFieldContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Global.theme.color(for: .mainBackground)
        self.clearBackgrounds(from: self.scrollView)
        self.paintSeparatorViews()
        
        self.amountFieldContainer.addSubviewsAndFill(self.amountFieldView)
        self.dateFieldContainer.addSubviewsAndFill(self.dateFieldView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Recursive function that clears the background of `superview` and its subviews.
    private func clearBackgrounds(from superview: UIView) {
        if let stackView = superview as? UIStackView {
            for subview in stackView.arrangedSubviews {
                self.clearBackgrounds(from: subview)
            }
        } else {
            superview.backgroundColor = .clear
            for subview in superview.subviews {
                self.clearBackgrounds(from: subview)
            }
        }
    }
    
    private func paintSeparatorViews() {
        for separatorView in self.separatorViews {
            separatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
    }
    
}

private extension ExpenseFormView {
    
    @objc func handleTapOnView() {
        self.endEditing(true)
    }
    
}
