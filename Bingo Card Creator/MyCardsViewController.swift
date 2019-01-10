//
//  ViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-08.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation

class MyCardsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        let sampleCardListArray: [String] = ["My First Card", "My Second Card", "My Third Card"]
        
        CardListTable.beginUpdates()
        CardListTable.insertRows(at: [IndexPath(row: sampleCardListArray.count - 1, section: 0)], with: .automatic)
        CardListTable.endUpdates()
        
    }
    
    @IBOutlet weak var CardListTable: UITableView!
    
    
    
    
}




