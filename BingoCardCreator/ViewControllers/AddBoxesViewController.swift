//
//  AddBoxesViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddBoxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var newCard: NSManagedObject?
    var arrayOfPendingBoxes: [BoxContents] = []
    var sizeOfGrid: Int?
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newCard!.value(forKey: "title") as? String
        //self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
//        addBoxToCardButton.layer.cornerRadius = 10
//        addBoxToCardButton.layer.applySketchShadow()
        
        //tableview stuff
        addBoxesTableView.delegate = self
        addBoxesTableView.dataSource = self
        
        addBoxesTableView.tableFooterView = UIView()
        
        print(self.tableViewHeightConstraint as Any)
        
        
        
        self.tableViewHeightConstraint.constant = addBoxesTableView.contentSize.height + 5
        self.addBoxesTableView.needsUpdateConstraints()
        
        self.mainStackViewWidthConstraint.constant = self.view.frame.width
        self.mainStackViewHeightConstraint.constant = previewBingoCard.frame.height + addBoxesTableView.contentSize.height + addBoxToCardButton.frame.height
        
        self.mainStackView.needsUpdateConstraints()
        
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
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        previewBingoCard.addGestureRecognizer(longPressGesture)
        
        if newCard != nil {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ownerCard.title == %@", newCard?.value(forKey: "title") as! CVarArg)
            
            do {
                let boxesToLoad = try context.fetch(fetchRequest)
                
                for box in boxesToLoad {
                    arrayOfPendingBoxes.append(box)
                }
            } catch {
                print("Could not load pre-existing boxes.")
            }
            print(arrayOfPendingBoxes)
            previewBingoCard.reloadData()
            checkIfCardIsDone()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var mainStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var addBoxesTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addBoxToCardButton: UIButton!
    @IBAction func addBoxToCard(_ sender: Any) {
        
        let boxTitleCell = addBoxesTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BingoBoxTextFieldTableViewCell
        
        let boxTitle = boxTitleCell.titleTextField.text!
        
        for box in arrayOfPendingBoxes {
            if boxTitle == box.boxTitle {
                print("Please give box a unique name.")
                return
            }
        }
        
        if boxTitle != "" {
            self.save(ownerCard: newCard!, boxTitle: boxTitle, complete: false)
        } else {
            print("Please enter a title for this box.")
            return
        }
        
        
        boxTitleCell.titleTextField.text = ""
        
        previewBingoCard.reloadData()
        
        checkIfCardIsDone()
        
    }
    
    func save(ownerCard: NSManagedObject, boxTitle: String, complete: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BoxContents", in: context)!
        
        let boxContents = BoxContents(entity: entity, insertInto: context)
        
        boxContents.setValue(boxTitle, forKeyPath: "boxTitle")
        boxContents.setValue(complete, forKey: "complete")
        boxContents.setValue(ownerCard, forKey: "ownerCard")
        
        arrayOfPendingBoxes.append(boxContents)
        
        assignPositionsToBoxes()
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save BoxContents. \(error)")
        }
        
    }
    
    @objc func deleteBox(_ sender: UIButton) {
        
        var boxToDelete: [BoxContents]?
        let titleOfBoxToDelete: String? = sender.layer.value(forKey: "boxTitle") as? String
        
        print("going to delete: ", titleOfBoxToDelete!)
        
        let boxToRemoveFromArray = arrayOfPendingBoxes.filter { $0.boxTitle == titleOfBoxToDelete! }
        print("boxToRemoveFromArray: ", boxToRemoveFromArray)
        let indexOfBoxToDelete = arrayOfPendingBoxes.firstIndex(of: boxToRemoveFromArray[0])
        
        
        let indexPath: IndexPath = [0, indexOfBoxToDelete!]
        print(indexPath)
        
        do {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "boxTitle == %@", titleOfBoxToDelete! as CVarArg)
            boxToDelete = try context.fetch(fetchRequest) as [BoxContents]
            print(boxToDelete!)
            for box in boxToDelete! {
                context.delete(box)
            }
        } catch {
            print("Could not delete box.", error.localizedDescription)
        }
        
        arrayOfPendingBoxes.remove(at: indexPath.row)
        previewBingoCard.deleteItems(at: [indexPath])
        
        checkIfCardIsDone()
        
    }
    
    @IBOutlet weak var navbarSaveButton: UIBarButtonItem!
    
    func checkIfCardIsDone() {
        if arrayOfPendingBoxes.count == sizeOfGrid! * sizeOfGrid! {
            navbarSaveButton.isEnabled = true
            addBoxToCardButton.isEnabled = false
        } else {
            navbarSaveButton.isEnabled = false
            addBoxToCardButton.isEnabled = true
        }
    }
    
    func assignPositionsToBoxes() {
        for box in arrayOfPendingBoxes {
            box.positionInCard = Float(arrayOfPendingBoxes.firstIndex(of: box)!)
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
        
        let boxTitle = cardArray[indexPath.row].boxTitle
        
        cell.previewCardBingoBoxLabel.text = boxTitle
        
        cell.previewCardDeleteBoxButton.layer.cornerRadius = 7.5
        cell.previewCardDeleteBoxButton?.layer.setValue(cardArray[indexPath.row].boxTitle, forKey: "boxTitle")
        cell.previewCardDeleteBoxButton?.addTarget(self, action: #selector(deleteBox), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        print("moving from ", sourceIndexPath.row, " to ", destinationIndexPath.row)
        let temp = arrayOfPendingBoxes.remove(at: sourceIndexPath.item)
        
        arrayOfPendingBoxes.insert(temp, at: destinationIndexPath.item)
        print(arrayOfPendingBoxes)
        
        assignPositionsToBoxes()
        
        
        do {
            try context.save()
            print("saved context(outer)")
            
        } catch {
            print("Could not save moved item's new location.")
        }
        
        
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = previewBingoCard.indexPathForItem(at: gesture.location(in: previewBingoCard)) else {
                break
            }
            previewBingoCard.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            previewBingoCard.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            previewBingoCard.endInteractiveMovement()
        default:
            previewBingoCard.cancelInteractiveMovement()
        }
    }
    
    
    // begin tableview stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellPrototypes = ["labelTableCell", "titleTableCell"]
        
        let cell = addBoxesTableView.dequeueReusableCell(withIdentifier: cellPrototypes[indexPath.section], for: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return "Box Title".uppercased()
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
        
        //print(newCard!.value(forKey: "contents")!)
        self.performSegue(withIdentifier: "AddBoxesToHomePage", sender: self)
        
    }
    
    @IBAction func cancelCardBarButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addBoxesPageToCardDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBoxesPageToCardDetails" {
            
            let titleToDelete = newCard?.value(forKey: "title")
            print("removing contents of ", titleToDelete!)
            
//            var boxesToDelete: [BoxContents]?
//
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // delete boxes belonging to card
//            do {
//                let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
//                fetchRequest.predicate = NSPredicate(format: "ownerCard.title == %@", titleToDelete as! CVarArg)
//
//                boxesToDelete = try context.fetch(fetchRequest) as [BoxContents]
//
//                for box in boxesToDelete! {
//                    context.delete(box)
//                }
//            } catch {
//                print("Could not delete card contents.", error.localizedDescription)
//            }
            
            let destinationVC = segue.destination as! CardDetailsViewController
            destinationVC.newCard = newCard!
        } else if segue.identifier == "AddBoxesToHomePage" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                try context.save()
            } catch {
                print("Failed to save context while preparing for save segue.")
            }
        }
    }
    
    
}
