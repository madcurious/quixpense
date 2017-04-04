//
//  _EFEVCDPVCSwitchCell.swift
//  Spare
//
//  Created by Matt Quiros on 30/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol _EFEVCDPVCSwitchCellDelegate {
    
    func switchCellDidToggle(_ on: Bool, for bound: DateRange.Bound)
    
}

class _EFEVCDPVCSwitchCell: UITableViewCell {
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var bound = DateRange.Bound.from {
        didSet {
            if self.bound == .from {
                self.fieldLabel.text = "From"
            } else {
                self.fieldLabel.text = "To"
            }
            self.setNeedsLayout()
        }
    }
    
    var isOn: Bool {
        get {
            return self.switchView.isOn
        }
        set {
            self.switchView.isOn = newValue
        }
    }
    
    var delegate: _EFEVCDPVCSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldLabel.font = Global.theme.font(for: .regularText)
        self.fieldLabel.textColor = Global.theme.color(for: .cellMainText)
        
        self.switchView.addTarget(self, action: #selector(handleValueChangeOnSwitchView), for: .valueChanged)
        
        self.selectionStyle = .none
    }
    
    func handleValueChangeOnSwitchView() {
        if let delegate = self.delegate {
            delegate.switchCellDidToggle(self.switchView.isOn, for: self.bound)
        }
    }
    
}
