//
//  SegmentedControlTableViewCell.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit

class SegmentedControlTableViewCell: UITableViewCell {

    var selection1 = 0
    var selection2 = 0
    var selection3 = 0
    
    @IBAction func selection1Changed(_ sender: UISegmentedControl) {
        selection1 = sender.selectedSegmentIndex
    }
    
    @IBAction func selection2Changed(_ sender: UISegmentedControl) {
        selection2 = sender.selectedSegmentIndex
    }
    
    @IBAction func selection3Changed(_ sender: UISegmentedControl) {
        selection3 = sender.selectedSegmentIndex
    }
}
