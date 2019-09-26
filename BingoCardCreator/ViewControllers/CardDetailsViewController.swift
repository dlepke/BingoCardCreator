//
//  CardDetailsViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CardDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var newCard: NSManagedObject?
    
    
    let completionPoint = ["Single Line", "Whole Card"]
    let cardSize = [3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenSwipedDown()
        
        //self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        cardDetailsTableView.delegate = self
        cardDetailsTableView.dataSource = self
        
        cardDetailsTableView.tableFooterView = UIView()

        cardDetailsTableViewHeightConstraint.constant = cardDetailsTableView.contentSize.height + 5
        cardDetailsTableView.needsUpdateConstraints()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var cardDetailsTableViewHeightConstraint: NSLayoutConstraint!
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellPrototypes = ["plainTableCell", "textFieldTableCell", "segmentedControlTableCell", "segmentedControlTableCell2"]
        
        
        
        if indexPath == [1, 0] {
            let cell: TextInputTableViewCell = cardDetailsTableView.dequeueReusableCell(withIdentifier: cellPrototypes[indexPath.section], for: indexPath) as! TextInputTableViewCell
            return cell
        } else {
            let cell = cardDetailsTableView.dequeueReusableCell(withIdentifier: cellPrototypes[indexPath.section], for: indexPath)
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 1:
            return "Card Title".uppercased()
        case 2:
            return "Winning Condition".uppercased()
        case 3:
            return "Card Size".uppercased()
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if section == 0 {
            headerView.frame.size = CGSize(width: 0, height: 0)
            return headerView
        }
        
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section > 0 {
            return 30
        } else {
            return 1
        }
    }
    
    
    @IBOutlet weak var cardDetailsTableView: UITableView!
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toAddBoxesPage" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
            }
            
            print("checking if segue to addboxes page should run")
            
            let textFieldCell = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextInputTableViewCell
            
            let cardTitle = textFieldCell.sendText()
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BingoCard")
            
            do {
                
                let cardsInStorage = try managedContext.fetch(fetchRequest)
                
                if cardTitle == "" {
                    print("title is empty")
                    let alert = UIAlertController(title: "Title Required", message: "Please give your card a title.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return false
                }
                
                for card in cardsInStorage {
                    if cardTitle == card.value(forKeyPath: "title") as? String {
                        print("title already exists")
                        let alert = UIAlertController(title: "Card Title Already Exists", message: "Please give card a unique name.", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return false
                    }
                }
            } catch {
                print("\(error)")
            }
        }
        // all checks passed?
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBoxesPage" {
            
            let textFieldCell = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextInputTableViewCell
            
            let cardTitle = textFieldCell.sendText()
            
            let segmentedControlCell1 = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SegmentedControlTableViewCell
            
            let selection1 = segmentedControlCell1.selection1
            
            let segmentedControlCell2 = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! SegmentedControlTableViewCell
            
            let selection2 = segmentedControlCell2.selection2
            
            
            self.save(title: cardTitle, completionPoint: completionPoint[selection1], cardSize: cardSize[selection2])

            let destinationVC = segue.destination as! AddBoxesViewController
            destinationVC.newCard = newCard!
            
        } else if segue.identifier == "createCardToHomePage" && newCard != nil {
            let titleToDelete = newCard?.value(forKey: "title")
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
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
                print("Could not save context on cancel.")
            }
        }
    }
    
    func save(title: String, completionPoint: String, cardSize: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if newCard == nil {
            let entity = NSEntityDescription.entity(forEntityName: "BingoCard", in: managedContext)!
            newCard = BingoCard(entity: entity, insertInto: managedContext)
        }
        
        newCard!.setValue(title, forKey: "title")
        newCard!.setValue(completionPoint, forKey: "completionPoint")
        newCard!.setValue(cardSize, forKey: "cardSize")
        
        let uuid = UUID()
        newCard!.setValue(uuid, forKey: "uuid")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func cancelCardFromDetailsPage(_ sender: Any) {        
        self.performSegue(withIdentifier: "createCardToHomePage", sender: self)
        
    }
    
    @IBAction func unwindToCardDetails(segue: UIStoryboardSegue) {
        //print(cardsInStorage)
    }
    
}
