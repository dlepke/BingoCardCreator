//
//  CompletionPointSegmentedControlTableViewCell.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit

class CompletionPointSegmentedControlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var proofRequiredSegmentedControl: UISegmentedControl!
    
    let proofOptions = ["none", "camera", "signature"]

    var selection = "none"
    
    @IBAction func completionPointChanged(_ sender: UISegmentedControl) {
        selection = proofOptions[sender.selectedSegmentIndex]
    }
    
    func resetSelection() {
        proofRequiredSegmentedControl.selectedSegmentIndex = 0
    }
    
}
