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
        
        updateTableViewFromStorage()
        //print(cardsInStorage)
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            //handle delete
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            let titleToDelete = self.cardsInStorage[indexPath.row].value(forKey: "title")!
            
            do {
                let fetchRequest: NSFetchRequest<BingoCard> = BingoCard.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@", titleToDelete as! CVarArg)
                
                let cardToDelete = try context.fetch(fetchRequest)
                
                context.delete(cardToDelete[0])
            } catch {
                print("Could not delete card.", error.localizedDescription)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save after deletion.")
            }
            
            self.updateTableViewFromStorage()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            //handle edit
            print("editing me!", self.cardsInStorage[indexPath.row].value(forKey: "title")!)
            self.performSegue(withIdentifier: "HomePageToCardDetails", sender: self)
        }
        
        editAction.backgroundColor = .lightGray
        
        return [deleteAction, editAction]
    }
    
    func updateTableViewFromStorage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BingoCard")
            self.cardsInStorage = try context.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error)")
        }
        
        self.tableView.reloadData()
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
        } else if segue.identifier == "HomePageToCardDetails" {
            if let sender = sender as? UITableViewCell {
                let destinationVC = segue.destination as? CardDetailsViewController
                let selectedCard = sender.textLabel!.text
                for card in cardsInStorage {
                    if card.value(forKeyPath: "title") as? String == selectedCard {
                        destinationVC!.newCard = card
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToMyCards(segue: UIStoryboardSegue) {
        //print(cardsInStorage)
    }

}




