//
//  ViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-08.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation

class MyCardsViewController: UITableViewController {
    

    
    let sampleCardListArray: [String] = ["My First Card", "My Second Card", "My Third Card"]
    var myCards: [BingoCard?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myCards.count

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bingo Card Table Cell", for: indexPath)
        
        print("my cards: ", myCards)
        
        cell.textLabel?.text = myCards[indexPath.row]!.title
            
        return cell
        
    }

}




