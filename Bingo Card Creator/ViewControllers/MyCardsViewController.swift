//
//  ViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-08.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MyCardsViewController: UITableViewController {
    
    var cardsInStorage: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BingoCard")
        
        do {
            cardsInStorage = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error)")
        }
        
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

        cell.textLabel?.text = cardsInStorage[indexPath.row].value(forKeyPath: "title") as? String
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCardView" {
            let sender = sender as! UITableViewCell
            
            let destinationVC = segue.destination as? PlayGameViewController
            
            let selectedCard = sender.textLabel!.text
            
            for card in cardsInStorage {
                if card.value(forKeyPath: "title") as? String == selectedCard {
                    //print("found this: ", card)
                    
                    destinationVC!.currentBingoCard = card
                }
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print(cardsInStorage)
    }

}




