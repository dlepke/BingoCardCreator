//
//  AddBoxesViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit
import os.log
import CoreData

class AddBoxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var newCard: NSManagedObject?
    var arrayOfPendingBoxes: [BoxContents] = []
    var sizeOfGrid: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("received: ", newCard)
        
        self.title = newCard!.value(forKey: "title") as? String
        self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        addBoxToCardButton.layer.cornerRadius = 10
        addBoxToCardButton.layer.applySketchShadow()
        
        //tableview stuff
        addBoxesTableView.delegate = self
        addBoxesTableView.dataSource = self
        
        addBoxesTableView.tableFooterView = UIView()
        
        self.tableViewHeightConstraint.constant = addBoxesTableView.contentSize.height
        self.addBoxesTableView.needsUpdateConstraints()
        
        self.contentViewWidthConstraint.constant = self.view.frame.width
        self.contentViewHeightConstraint.constant = previewBingoCard.frame.height + addBoxesTableView.contentSize.height + addBoxToCardButton.frame.height
        
        self.contentView.needsUpdateConstraints()
        
        //collectionview stuff
        previewBingoCard.delegate = self
        previewBingoCard.dataSource = self
        
        previewBingoCardFlowLayout.minimumLineSpacing = 0
        previewBingoCardFlowLayout.minimumInteritemSpacing = 0
        previewBingoCardFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let totalWidth = view.frame.width

        sizeOfGrid = newCard!.value(forKey: "cardSize") as? Int
        let widthOfCell = CGFloat(Int(totalWidth) / sizeOfGrid!)
        let heightOfCell = CGFloat(Int(totalWidth) / sizeOfGrid!)
        previewBingoCardFlowLayout.itemSize = CGSize(width: widthOfCell, height: heightOfCell)
        
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addBoxesTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addBoxToCardButton: UIButton!
    @IBAction func addBoxToCard(_ sender: Any) {
        
        let boxTitleCell = addBoxesTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BingoBoxTextFieldTableViewCell
        let boxDetailsCell = addBoxesTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! BingoBoxTextFieldTableViewCell
        let proofRequiredCell = addBoxesTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! CompletionPointSegmentedControlTableViewCell
        
        let boxTitle = boxTitleCell.titleTextField.text!
        let boxDetails = boxDetailsCell.detailsTextField.text!
        let proofRequired = proofRequiredCell.selection
        
        self.save(ownerCard: newCard!, boxTitle: boxTitle, boxDetails: boxDetails, proofRequired: proofRequired, complete: false, proof: nil)
        
        
        boxTitleCell.titleTextField.text = ""
        boxDetailsCell.detailsTextField.text = ""
        
        previewBingoCard.reloadData()
        
        checkIfCardIsDone()
        
    }
    
    func save(ownerCard: NSManagedObject, boxTitle: String, boxDetails: String, proofRequired: String, complete: Bool, proof: UIImage?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BoxContents", in: managedContext)!
        
        let boxContents = BoxContents(entity: entity, insertInto: managedContext)
        
        boxContents.setValue(boxTitle, forKeyPath: "boxTitle")
        boxContents.setValue(boxDetails, forKeyPath: "boxDetails")
        boxContents.setValue(proofRequired, forKeyPath: "proofRequired")
        boxContents.setValue(complete, forKey: "complete")
        boxContents.setValue(proof, forKey: "proof")
        boxContents.setValue(ownerCard, forKey: "ownerCard")
        
        arrayOfPendingBoxes.append(boxContents)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save BoxContents. \(error)")
        }
        
    }
    
    @IBOutlet weak var navbarSaveButton: UIBarButtonItem!
    
    func checkIfCardIsDone() {
        if arrayOfPendingBoxes.count == sizeOfGrid! * sizeOfGrid! {
            navbarSaveButton.isEnabled = true
            addBoxToCardButton.isEnabled = false
        }
    }
    
    // begin collectionview stuff
    @IBOutlet weak var previewBingoCard: UICollectionView!
    @IBOutlet weak var previewBingoCardFlowLayout: UICollectionViewFlowLayout!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cardArray = arrayOfPendingBoxes
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = previewBingoCard.dequeueReusableCell(withReuseIdentifier: "previewBingoBox", for: indexPath) as! PreviewCardBingoBoxCell
        
        cell.layer.borderColor = #colorLiteral(red: 0.3764705882, green: 0.3529411765, blue: 0.337254902, alpha: 0.5)
        cell.layer.borderWidth = 1
        
        let cardArray = arrayOfPendingBoxes
        cell.previewCardBingoBoxLabel.text = cardArray[indexPath.row].boxTitle
        
        return cell
    }
    
    
    // begin tableview stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellPrototypes = ["labelTableCell", "titleTableCell", "detailsTableCell", "proofRequiredTableCell"]
        
        let cell = addBoxesTableView.dequeueReusableCell(withIdentifier: cellPrototypes[indexPath.section], for: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return "Box Title".uppercased()
        case 2:
            return "Box Details".uppercased()
        case 3:
            return "Proof of Completion".uppercased()
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

    @IBAction func saveCardBarButton(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "createCardToHomePage", sender: self)
        
    }
    
    @IBAction func cancelCardBarButton(_ sender: Any) {
        
        let titleToDelete = newCard?.value(forKey: "title")
        
        var boxesToDelete: [BoxContents]?
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // delete boxes belonging to card
        do {
            let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ownerCard.title == %@", titleToDelete as! CVarArg)
            
            boxesToDelete = try context.fetch(fetchRequest) as [BoxContents]
            
            for box in boxesToDelete! {
                context.delete(box)
            }
        } catch {
            print("Could not delete card contents.", error.localizedDescription)
        }
        
        // delete actual card
        
        do {
            let fetchRequest: NSFetchRequest<BingoCard> = BingoCard.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", titleToDelete as! CVarArg)
            
            let cardToDelete = try context.fetch(fetchRequest) as [BingoCard]
            
            print("deleting: ", cardToDelete)
            
            context.delete(cardToDelete[0])
        } catch {
            print("Could not delete card.", error.localizedDescription)
        }
        
        do {
            try context.save()
        } catch {
            print("Could not save context on cancel.")
        }
     
        self.performSegue(withIdentifier: "createCardToHomePage", sender: self)
    }
    
    
}
