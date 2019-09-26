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
        
        let trimmedText = textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedText!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let identifier = self.reuseIdentifier
        let mainView = self.superview?.superview!
        
        if identifier == "titleTableCell" {
            let buttonToPress = mainView?.subviews[1] as! UIButton
            buttonToPress.sendActions(for: .touchUpInside)
            textField.text = ""
        } else if identifier == "textFieldTableCell" {
            self.endEditing(true)
        }
        return true
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


