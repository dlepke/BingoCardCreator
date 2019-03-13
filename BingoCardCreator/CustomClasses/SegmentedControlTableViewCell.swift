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
    
    @IBOutlet weak var segmentedControl1: UISegmentedControl!
    @IBOutlet weak var segmentedControl2: UISegmentedControl!
    
    
    @IBAction func selection1Changed(_ sender: UISegmentedControl) {
        selection1 = sender.selectedSegmentIndex
    }
    
    @IBAction func selection2Changed(_ sender: UISegmentedControl) {
        selection2 = sender.selectedSegmentIndex
    }
}
