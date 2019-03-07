//
//  ImportBingoCard.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-03-06.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension BingoCard {
    
    enum Keys: String {
        case Title = "title"
        case CardSize = "cardSize"
        case CompletionPoint = "completionPoint"
        case Contents = "contents"
    }
    
    static func importData(from url: URL) {
        
        guard let dictionary = NSDictionary(contentsOf: url),
            let bingoCard = dictionary as? [String: AnyObject],
            let title = bingoCard[Keys.Title.rawValue] as? String,
            let cardSize = bingoCard[Keys.CardSize.rawValue] as? Float,
            let completionPoint = bingoCard[Keys.CompletionPoint.rawValue] as? String,
            let contents = bingoCard[Keys.Contents.rawValue] as? [BoxContents] else {
                return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BingoCard", in: managedContext)!
        let newBingoCard = BingoCard(entity: entity, insertInto: managedContext)
        
        newBingoCard.setValue(title, forKey: "title")
        newBingoCard.setValue(cardSize, forKey: "cardSize")
        newBingoCard.setValue(completionPoint, forKey: "completionPoint")
        newBingoCard.setValue(contents, forKey: "contents")
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save imported card to context.")
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to remove imported item from sandbox.")
        }
    }
    
    func exportToFileURL() -> URL? {
        
        let urlContents: [String : Any] = ["title": self.title!, "cardSize": self.cardSize, "completionPoint": self.completionPoint!, "contents": self.contents as Any]
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let urlTitle = self.title!
        
        let saveFileURL = path.appendingPathComponent("\(urlTitle).bingocard")
        (urlContents as NSDictionary).write(to: saveFileURL, atomically: true)
        
        return saveFileURL
        
    }

}
