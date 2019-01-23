//
//  HomepageMenuPopoverViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-22.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class HomePageMenuPopoverViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("popover view loaded!")
        
        menuTableView.tableFooterView = UIView(frame: .zero)
        
        
        let preferredHeight = Int(menuTableView.contentSize.height)
        self.preferredContentSize = CGSize(width: 150, height: preferredHeight)
        self.modalPresentationStyle = .popover
        
    }

    
    @IBOutlet var menuTableView: UITableView!
    

}
