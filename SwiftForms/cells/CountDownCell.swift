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
    }
    
    override class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    // MARK: Actions
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @objc internal func valueChanged(_ sender: UIDatePicker) {
        rowDescriptor?.value = sender.countDownDuration as AnyObject
        let addedTime = Date().addingTimeInterval(sender.countDownDuration)
        valueLabel.text = defaultDateFormatter.string(from: addedTime)
        update()
    }
        
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
       guard let row = selectedRow as? CountDownCell else { preconditionFailure("Type was not configured properly") }
        
        if row.rowDescriptor?.value == nil {
            let date = Date()
            row.rowDescriptor?.value = date as AnyObject
            row.valueLabel.text = row.defaultDateFormatter.string(from: date)
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
}
