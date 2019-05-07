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
    
    static func importData(from url: URL) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BingoCard", in: managedContext)!
        let newBingoCard = BingoCard(entity: entity, insertInto: managedContext)
        
        
        do {
            let urlData = try Data(contentsOf: url)
            
            
            
            let decodedURLData = try JSONDecoder().decode(BingoCardCodable.self, from: urlData)
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BingoCard")
            let cardsInStorage = try managedContext.fetch(fetchRequest)
            
            func checkifTitleIsUnique(title: String) -> Bool {
                for card in cardsInStorage {
                    if title == card.value(forKeyPath: "title") as? String {
                        print("title already exists")
                        return false
                    }
                }
                return true
            }
            
            
            var counter = 0
            var title = decodedURLData.title
            
            while !checkifTitleIsUnique(title: title) {
                counter += 1
                title = decodedURLData.title + "\(counter)"
            }
            
    
            newBingoCard.title = title
            newBingoCard.cardSize = decodedURLData.cardSize
            newBingoCard.completionPoint = decodedURLData.completionPoint
            
            for bingoBox in decodedURLData.contents {
                let boxContentsEntity = NSEntityDescription.entity(forEntityName: "BoxContents", in: managedContext)!
                let newBingoBox = BoxContents(entity: boxContentsEntity, insertInto: managedContext)
                
                newBingoBox.setValue(bingoBox.boxTitle, forKey: "boxTitle")
                newBingoBox.setValue(bingoBox.boxDetails, forKey: "boxDetails")
                newBingoBox.setValue(bingoBox.proofRequired, forKey: "proofRequired")
                newBingoBox.setValue(bingoBox.complete, forKey: "complete")
                newBingoBox.setValue(newBingoCard, forKey: "ownerCard")
                
                try managedContext.save()
            }
            
            //print(newBingoCard)
        } catch {
            print("Unable to get data from url.")
        }
        
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
        
        var boxContentsToEncode: [BoxContentsCodable] = []
        
        for bingoBoxRaw in self.contents! {
            
//            print(bingoBoxRaw)
            let bingoBox = (bingoBoxRaw as? BoxContents)!
            print(bingoBox)
            let codableBingoBox = BoxContentsCodable(boxTitle: bingoBox.boxTitle!, boxDetails: bingoBox.boxDetails!, proofRequired: bingoBox.proofRequired!, positionInCard: bingoBox.positionInCard, complete: false)
            boxContentsToEncode.append(codableBingoBox)
        }
        
        let bingoCardToEncode = BingoCardCodable(uuid: self.uuid!, title: self.title!, cardSize: self.cardSize, completionPoint: self.completionPoint!, contents: boxContentsToEncode)
        
        let saveFileURL: URL = URL(string: "www.google.ca")!
        
        do {
            let encoder = JSONEncoder()
            let contentsAsData: Data = try encoder.encode(bingoCardToEncode)
            
            let url = URL(string: "https://www.urbanmythapps.com/bingocards")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.uploadTask(with: request, from: contentsAsData) {
                data, response, error in
                
                if let error = error {
                    print("error: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("server error")
                    return
                }
                
                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print("got data: \(dataString)")
                }
            }
        
            task.resume()
            
            /*
             guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
             return nil
             }
             
            let urlTitle = self.title!
            saveFileURL = path.appendingPathComponent("\(urlTitle).bingocard")
            
            FileManager.default.createFile(atPath: saveFileURL.path, contents: contentsAsData, attributes: nil) */
            
        } catch {
            print("Failed to convert contents to data.")
        }
        return saveFileURL
    }
}

struct BingoCardCodable: Codable {
    let title: String
    let cardSize: Float
    let completionPoint: String
    let contents: [BoxContentsCodable]
    let uuid: UUID
    
    init(uuid: UUID, title: String, cardSize: Float, completionPoint: String, contents: [BoxContentsCodable]) {
        self.title = title
        self.cardSize = cardSize
        self.completionPoint = completionPoint
        self.contents = contents
        self.uuid = uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case cardSize
        case completionPoint
        case contents
        case uuid
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(cardSize, forKey: .cardSize)
        try container.encode(completionPoint, forKey: .completionPoint)
        try container.encode(contents, forKey: .contents)
        try container.encode(uuid, forKey: .uuid)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        cardSize = try values.decode(Float.self, forKey: .cardSize)
        completionPoint = try values.decode(String.self, forKey: .completionPoint)
        contents = try values.decode([BoxContentsCodable].self, forKey: .contents)
        uuid = try values.decode(UUID.self, forKey: .uuid)
    }
}

struct BoxContentsCodable: Codable {
    let boxTitle: String
    let boxDetails: String
    let proofRequired: String
    let positionInCard: Float
    let complete: Bool
    //let proof: Data
    
    init(boxTitle: String, boxDetails: String, proofRequired: String, positionInCard: Float, complete: Bool) {
        self.boxTitle = boxTitle
        self.boxDetails = boxDetails
        self.proofRequired = proofRequired
        self.positionInCard = positionInCard
        self.complete = complete
        //self.proof = proof
    }
    
    enum CodingKeys: String, CodingKey {
        case boxTitle
        case boxDetails
        case proofRequired
        case positionInCard
        case complete
        //case proof
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boxTitle, forKey: .boxTitle)
        try container.encode(boxDetails, forKey: .boxDetails)
        try container.encode(proofRequired, forKey: .proofRequired)
        try container.encode(positionInCard, forKey: .positionInCard)
        try container.encode(complete, forKey: .complete)
        //try container.encode(proof, forKey: .proof)
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        boxTitle = try values.decode(String.self, forKey: .boxTitle)
        boxDetails = try values.decode(String.self, forKey: .boxDetails)
        proofRequired = try values.decode(String.self, forKey: .proofRequired)
        positionInCard = try values.decode(Float.self, forKey: .positionInCard)
        complete = try values.decode(Bool.self, forKey: .complete)
        //proof = try values.decode(Data.self, forKey: .proof)
        
        
    }
}
