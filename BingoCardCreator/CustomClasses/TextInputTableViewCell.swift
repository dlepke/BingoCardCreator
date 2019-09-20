//
//  TextInputTableViewCell.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit


class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func editingChanged(_ sender: Any) {
        textField.delegate = self
    }
    
    
    func configure(text: String?, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
        
        textField.accessibilityValue = text
        textField.accessibilityLabel = placeholder
    }
    
    func sendText() -> String {
        return (textField?.text)!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("running shouldchangecharactersin")
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let subStringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - subStringToReplace.count + string.count
        return count <= 25
    }
    
}


