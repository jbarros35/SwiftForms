//
//  FormDateCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2016 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormDateCell: FormValueCell {
    
    // MARK: Properties
    open var datePicker = UIDatePicker()
    private let hiddenTextField = UITextField(frame: CGRect.zero)
    
    private let defaultDateFormatter = DateFormatter()
    
    // MARK: FormBaseCell
    open override func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        hiddenTextField.isAccessibilityElement = false
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(FormDateCell.valueChanged(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && hiddenTextField.inputAccessoryView == nil {
            hiddenTextField.inputAccessoryView = inputAccesoryView()
        }
        titleLabel.text = rowDescriptor?.title
        let dateConfiguration = rowDescriptor?.configuration.date
        if let rowType = rowDescriptor?.type {
            switch rowType {
            case .date:
                datePicker.datePickerMode = .date
                defaultDateFormatter.dateStyle = .long
                defaultDateFormatter.timeStyle = .none
            case .time:
                datePicker.datePickerMode = .time
                defaultDateFormatter.dateStyle = .none
                defaultDateFormatter.timeStyle = .short
            case .countDownTimer:
                datePicker.datePickerMode = .countDownTimer
                datePicker.countDownDuration = TimeInterval(dateConfiguration?.countDownDuration ?? 60)
                datePicker.minuteInterval = dateConfiguration?.minuteInterval ?? 15
                defaultDateFormatter.dateStyle = .short
                defaultDateFormatter.timeStyle = .short
                return
            default:
                datePicker.datePickerMode = .dateAndTime
                defaultDateFormatter.dateStyle = .long
                defaultDateFormatter.timeStyle = .short
            }
        }
        
        if let date = rowDescriptor?.value as? Date {
            datePicker.date = date
            valueLabel.text = getDateFormatter().string(from: date)
        }
    }
    
    /// <#Description#>
    /// - Parameter formViewController: <#formViewController description#>
    /// - Parameter selectedRow: <#selectedRow description#>
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormDateCell else { preconditionFailure("Type was not configured properly") }
        
        if row.rowDescriptor?.value == nil {
            var date = Date()
            if let minuteInterval = row.rowDescriptor?.configuration.date.minuteInterval {
                date = Date().addingTimeInterval(TimeInterval(minuteInterval * 60))
            }
            row.rowDescriptor?.value = date as AnyObject
            row.valueLabel.text = row.getDateFormatter().string(from: date)
            row.update()
        }
        row.hiddenTextField.becomeFirstResponder()
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return hiddenTextField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @objc internal func valueChanged(_ sender: UIDatePicker) {
        rowDescriptor?.value = sender.date as AnyObject
        valueLabel.text = getDateFormatter().string(from: sender.date)
        update()
    }
    
    // MARK: Private interface
    
    fileprivate func getDateFormatter() -> DateFormatter {
        guard let dateFormatter = rowDescriptor?.configuration.date.dateFormatter else { return defaultDateFormatter }
        return dateFormatter
    }
}
