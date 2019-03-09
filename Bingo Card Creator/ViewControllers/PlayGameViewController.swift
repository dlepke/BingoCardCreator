//
//  PlayGameViewController.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-09.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlayGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var bingoCardCollectionView: UICollectionView!
    @IBOutlet weak var bingoCardFlow: UICollectionViewFlowLayout!
    
    var currentBingoCard: NSManagedObject?
    var contentsOfCurrentCard: [BoxContents]? = []
    
    let boxCompleteColor = #colorLiteral(red: 0.2784313725, green: 0.2901960784, blue: 0.2823529412, alpha: 1)
    let boxCompleteFontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6000000238)
    let boxNotCompleteColor = #colorLiteral(red: 0.3254901961, green: 0.4784313725, blue: 0.3529411765, alpha: 1)
    let boxNotCompleteFontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentBingoCard!.value(forKey: "title") as? String
        
        //self.view.backgroundColor = UIColor(patternImage: backgroundGradientImage(bounds: view.bounds))
        
        bingoCardCollectionView.dataSource = self
        bingoCardCollectionView.delegate = self
        
        bingoCardFlow.minimumLineSpacing = 0
        bingoCardFlow.minimumInteritemSpacing = 0
        bingoCardFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let totalWidth = view.frame.width
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        let totalHeight = view.frame.height - topPadding! - bottomPadding! - (self.navigationController?.navigationBar.frame.height)!
        let sizeOfGrid = currentBingoCard?.value(forKey: "cardSize") as? Int
        let widthOfCell = CGFloat(Int(totalWidth) / sizeOfGrid!)
        let heightOfCell = CGFloat(Int(totalHeight) / sizeOfGrid!)
        bingoCardFlow.itemSize = CGSize(width: widthOfCell, height: heightOfCell)

        
        // fetching card contents
        
        let titleOfCurrentCard = currentBingoCard!.value(forKey: "title") as? String
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ownerCard.title == %@", titleOfCurrentCard!)
        
        do {
            contentsOfCurrentCard = try context.fetch(fetchRequest) as [BoxContents] 
        } catch {
            print("Could not fetch card contents.", error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        let selectedBingoBox = contentsOfCurrentCard?[indexPath.row]
        
        if selectedBingoBox?.complete == true {
            selectedCell.backgroundColor = boxNotCompleteColor
            selectedCell.bingoBoxTitle.tintColor = boxNotCompleteFontColor
            selectedBingoBox?.complete = false
        } else {
            selectedCell.backgroundColor = boxCompleteColor
            selectedCell.bingoBoxTitle.tintColor = boxCompleteFontColor
            selectedBingoBox?.complete = true
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Could not save context on bingobox click.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellToDeselect = bingoCardCollectionView.cellForItem(at: indexPath) as! BingoBox
        let deselectedBingoBox = contentsOfCurrentCard?[indexPath.row]
        
        if deselectedBingoBox?.complete != true {
            cellToDeselect.backgroundColor = boxNotCompleteColor
            cellToDeselect.bingoBoxTitle.tintColor = boxNotCompleteFontColor
        }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsOfCurrentCard?.count ?? 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentBingoBox = contentsOfCurrentCard![indexPath.row]
        
        let cell = bingoCardCollectionView.dequeueReusableCell(withReuseIdentifier: "BingoBox", for: indexPath as IndexPath) as! BingoBox
        if currentBingoBox.complete {
            cell.backgroundColor = boxCompleteColor
            cell.bingoBoxTitle.tintColor = boxCompleteFontColor
        } else {
            cell.backgroundColor = boxNotCompleteColor
            cell.bingoBoxTitle.tintColor = boxNotCompleteFontColor
        }
        cell.bingoBoxTitle.text = currentBingoBox.boxTitle
        cell.bingoBoxTitle.textAlignment = .center
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.6039215686, green: 0.8823529412, blue: 0.6156862745, alpha: 1)
        
        if currentBingoBox.value(forKeyPath: "proofRequired") as? String == "camera" {
            cell.bingoBoxActionIcon.image = #imageLiteral(resourceName: "QuickActions_CapturePhoto")
        } else if currentBingoBox.value(forKeyPath: "proofRequired") as? String == "signature" {
            cell.bingoBoxActionIcon.image = #imageLiteral(resourceName: "QuickActions_Compose")
        } else {
            cell.bingoBoxActionIcon.image = nil
        }
        
        return cell
    }
    
    @IBAction func shareBingoCard(_ sender: Any) {
        
        guard let currentBingoCard = currentBingoCard as? BingoCard,
            let url = currentBingoCard.exportToFileURL() else {
                print("URL failed.")
                return
        }
        
//        let fakeURL: URL = URL(string: "http://www.google.ca")!
        
        print("url: ", url)
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}
