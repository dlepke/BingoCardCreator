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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        cardDetailsTableView.delegate = self
        cardDetailsTableView.dataSource = self
        
        cardDetailsTableView.tableFooterView = UIView()

        cardDetailsTableViewHeightConstraint.constant = cardDetailsTableView.contentSize.height
        cardDetailsTableView.needsUpdateConstraints()
        
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
            return "Free Square".uppercased()
        case 3:
            return "Winning Condition".uppercased()
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
        
    }
    
    @IBOutlet weak var cardDetailsTableView: UITableView!
    
    var newCard = NSManagedObject()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBoxesPage" {
            
            let textFieldCell = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextInputTableViewCell
            
            let cardTitle = textFieldCell.sendText()
            
            let segmentedControlCell1 = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SegmentedControlTableViewCell
            
            let selection1 = segmentedControlCell1.selection1
            
            let segmentedControlCell2 = cardDetailsTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! SegmentedControlTableViewCell
            
            let selection2 = segmentedControlCell2.selection2
            
            let freeSquare = [true, false]
            let completionPoint = ["Single Line", "Whole Card"]
            
            
            self.save(title: cardTitle, freeSquare: freeSquare[selection1], completionPoint: completionPoint[selection2])
        
            let destinationVC = segue.destination as! AddBoxesViewController
            destinationVC.newCard = newCard
//            print("sent: ", destinationVC.newCard)
        }
    }
    
    func save(title: String, freeSquare: Bool, completionPoint: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BingoCard", in: managedContext)!
        
        newCard = BingoCard(entity: entity, insertInto: managedContext)
        
        newCard.setValue(title, forKey: "title")
        newCard.setValue(freeSquare, forKey: "freeSquare")
        newCard.setValue(completionPoint, forKey: "completionPoint")
//        newCard.setValue(contents, forKey: "contents")
        
        do {
            try managedContext.save()
            print("Saved empty card: ", newCard)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}