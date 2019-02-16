//
//  PreviewCardBingoBoxCell.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import CoreData

class PreviewCardBingoBoxCell: UICollectionViewCell {
    
    @IBOutlet weak var previewCardBingoBoxLabel: UILabel!
    @IBOutlet weak var previewCardDeleteBoxButton: UIButton!
    

//    @IBAction func deleteBoxFromPreview(_ sender: Any) {
    
//        var boxToDelete: [BoxContents]?
//        let titleOfBoxToDelete: String? = previewCardBingoBoxLabel.text
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        print("going to delete: ", titleOfBoxToDelete!)
//
        // delete boxes belonging to card
//        do {
//            let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "boxTitle == %@", titleOfBoxToDelete! as CVarArg)
//
//            boxToDelete = try context.fetch(fetchRequest) as [BoxContents]
//            print(boxToDelete!)
//
//            for box in boxToDelete! {
//                context.delete(box)
//            }
//        } catch {
//            print("Could not delete card contents.", error.localizedDescription)
//        }
//
//        do {
//            let fetchRequest: NSFetchRequest<BoxContents> = BoxContents.fetchRequest()
//
//            boxToDelete = try context.fetch(fetchRequest) as [BoxContents]
//            print(boxToDelete!)
//
//        } catch {
//            print("Could not delete card contents.", error.localizedDescription)
//        }
//        self.removeFromSuperview()
//    }
}
