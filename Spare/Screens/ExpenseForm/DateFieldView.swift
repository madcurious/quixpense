//
//  DateFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 17/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class DateFieldView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var editButton: MDButton!
    @IBOutlet weak var editButtonLabel: UILabel!
    @IBOutlet weak var refreshButton: MDButton!
    @IBOutlet weak var refreshButtonImageView: UIImageView!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM yyyy, h:mm a"
        return formatter
    }()
    
    private lazy var datePicker = UIDatePicker(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearAllBackgroundColors()
        setDate(Date())
        
        iconImageView.image = UIImage.templateNamed("dateIcon")
        
        refreshButtonImageView.image = UIImage.templateNamed("cellAccessoryRefresh")
        
        datePicker.addTarget(self, action: #selector(handleValueChangeOnDatePicker), for: .valueChanged)
        
        applyTheme()
    }
    
    func setDate(_ date: Date) {
        editButtonLabel.text = dateFormatter.string(from: date)
    }
    
    @objc func handleValueChangeOnDatePicker() {
        setDate(datePicker.date)
    }
    
}

extension DateFieldView: Themeable {
    
    func applyTheme() {
        iconImageView.tintColor = Global.theme.color(for: .fieldIcon)
        editButtonLabel.font = Global.theme.font(for: .regularText)
        editButtonLabel.textColor = Global.theme.color(for: .regularText)
        refreshButtonImageView.tintColor = Global.theme.color(for: .cellAccessoryRefresh)
    }
    
}
