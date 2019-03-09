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
        
        
        do {
            let urlData = try Data(contentsOf: url)
            
            do {
                let unarchivedURLData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(urlData)
                print(unarchivedURLData!)
            } catch {
                print("Unable to unarchive data from url.")
            }
            
        } catch {
            print("Unable to get data from url.")
        }
        
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
        
        var saveFileURL: URL = URL(string: "www.google.ca")!
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        do {
            let contentsAsData: Data = try NSKeyedArchiver.archivedData(withRootObject: urlContents, requiringSecureCoding: false)
            
            let urlTitle = self.title!
            saveFileURL = path.appendingPathComponent("\(urlTitle).bingocard")
            
            FileManager.default.createFile(atPath: saveFileURL.path, contents: contentsAsData, attributes: nil)
            
            return saveFileURL
        } catch {
            print("Failed to convert contents to data.")
        }
        return saveFileURL
    }
}
