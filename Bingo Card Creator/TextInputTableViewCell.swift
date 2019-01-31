//
//  TextInputTableViewCell.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit


class TextInputTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    func configure(text: String?, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
        
        textField.accessibilityValue = text
        textField.accessibilityLabel = placeholder
    }
    
    func sendText() -> String {
        return (textField?.text)!
    }
    
    
}
