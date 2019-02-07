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
    
    var cardsInStorage = Storage.retrieveAll("BingoCards", from: .documents, as: [BingoCard].self)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("reloading cards list")
        cardsInStorage = Storage.retrieveAll("BingoCards", from: .documents, as: [BingoCard].self)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cardsInStorage.count

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bingo Card Table Cell", for: indexPath)
        
        cell.textLabel?.text = cardsInStorage[indexPath.row].title
            
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCardView" {
            let sender = sender as! UITableViewCell
            
            let destinationVC = segue.destination as? PlayGameViewController
            
            let selectedCard = sender.textLabel!.text
            
            if let found = cardsInStorage.index(where: { $0.title == selectedCard}) {
                let cardToShow = cardsInStorage[found]
                
                destinationVC!.currentBingoCard = cardToShow
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}




