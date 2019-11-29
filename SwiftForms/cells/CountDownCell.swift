//
//  CountDownCell.swift
//  Loxy4Layout
//
//  Created by Jose on 27/11/2019.
//  Copyright © 2019 Satcom. All rights reserved.
//
import UIKit

class CountDownCell: FormValueCell {

    private let datePicker = UIDatePicker()
    private let hiddenTextField = UITextField(frame: CGRect.zero)
    private let defaultDateFormatter = DateFormatter()
    
    override func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        hiddenTextField.isAccessibilityElement = false
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(self, action: #selector(CountDownCell.valueChanged(_:)), for: .valueChanged)
        defaultDateFormatter.dateFormat = "HH:mm"
    }
    
    override func update() {
        super.update()
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && hiddenTextField.inputAccessoryView == nil {
            hiddenTextField.inputAccessoryView = inputAccesoryView()
        }
        titleLabel.text = rowDescriptor?.title
        if let timeInterval = rowDescriptor?.value as? TimeInterval {
            // datePicker.date = date
            valueLabel.text = CountDownCell.stringFromTimeInterval(timeInterval)
            print(timeInterval)
        }
    }
    
    override class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    // MARK: Actions
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @objc internal func valueChanged(_ sender: UIDatePicker) {
        rowDescriptor?.value = sender.countDownDuration as AnyObject
        let addedTime = CountDownCell.stringFromTimeInterval(sender.countDownDuration)
        valueLabel.text = addedTime
        update()
    }
        
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
       guard let row = selectedRow as? CountDownCell else { preconditionFailure("Type was not configured properly") }
        
        if row.rowDescriptor?.value == nil {
            row.rowDescriptor?.value = 0.0 as AnyObject
            row.valueLabel.text = CountDownCell.stringFromTimeInterval(0.0)
            row.update()
        } else {
            guard let currentValue = row.rowDescriptor?.value as? TimeInterval else {
                return
            }
            row.valueLabel.text = CountDownCell.stringFromTimeInterval(currentValue)
            row.update()
        }
        row.hiddenTextField.becomeFirstResponder()
    }
    
    /// <#Description#>
    /// - Parameter interval: <#interval description#>
    fileprivate static func stringFromTimeInterval(_ interval: TimeInterval) -> String {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return hiddenTextField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
}
