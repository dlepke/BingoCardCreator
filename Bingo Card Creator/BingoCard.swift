//
//  BingoCard.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit
import Foundation

struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
    var complete: Bool
    var proof: UIImage?
}

struct PropertyKey {
    static let title = "title"
    static let freeSquare = "freeSquare"
    static let completionPoint = "completionPoint"
    static let contents = "contents"
}

class BingoCard: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(freeSquare, forKey: PropertyKey.freeSquare)
        aCoder.encode(completionPoint, forKey: PropertyKey.completionPoint)
        aCoder.encode(contents, forKey: PropertyKey.contents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyKey.title) as! String
        let freeSquare = aDecoder.decodeBool(forKey: PropertyKey.freeSquare)
        let completionPoint = aDecoder.decodeObject(forKey: PropertyKey.completionPoint) as! String
        let contents = aDecoder.decodeObject(forKey: PropertyKey.contents) as! [BoxContents]
        
        self.init(title: title , freeSquare: freeSquare, completionPoint: completionPoint, contents: contents)
    }
    
    
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
    
    init(title: String, freeSquare: Bool, completionPoint: String, contents: [BoxContents]) {
        
        self.title = title
        self.freeSquare = freeSquare
        self.completionPoint = completionPoint
        self.contents = contents
        
        super.init()
    }
    
    func createDataPath() throws {
        guard docPath == nil else { return }
        
        docPath = BingoCardDatabase.nextBingoCardDocPath()
        try FileManager.default.createDirectory(at: self.docPath!,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
    
    func saveCard() {
        // 1
//        guard let data = data else { return }

        // 2
        do {
            try createDataPath()
        } catch {
            print("Couldn't create save folder. " + error.localizedDescription)
            return
        }
        
        // 3
        let dataURL = docPath!.appendingPathComponent(PropertyKey.title)
        
        // 4
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: self,
                                                          requiringSecureCoding: false)
        
        // 5
        do {
            try codedData.write(to: dataURL)
        } catch {
            print("Couldn't write to save file: " + error.localizedDescription)
        }
        
    }
    
    func loadAllCards() -> [BingoCard]? {
        let dataURL = docPath!.appendingPathComponent(PropertyKey.title)
        guard let codedData = try? Data(contentsOf: dataURL) else { return nil }
        
        // 3
        let data = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [BingoCard]
        
        return data
    }
    

    var docPath: URL?
    
    init(docPath: URL) {
        super.init()
        self.docPath = docPath
//        let title = aDecoder.decodeObject(forKey: PropertyKey.title) as! String
//        let freeSquare = aDecoder.decodeBool(forKey: PropertyKey.freeSquare)
//        let completionPoint = aDecoder.decodeObject(forKey: PropertyKey.completionPoint) as! String
//        let contents = aDecoder.decodeObject(forKey: PropertyKey.contents) as! [BoxContents]

//        self.init(title: title , freeSquare: freeSquare, completionPoint: completionPoint, contents: contents)
    }
}

class BingoCardDatabase: NSObject {
    
    static let privateDocsDir: URL = {
        // 1
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // 2
        let documentsDirectoryURL = paths.first!.appendingPathComponent("PrivateDocuments")
        
        // 3
        do {
            try FileManager.default.createDirectory(at: documentsDirectoryURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Couldn't create directory")
        }
        print(documentsDirectoryURL.absoluteString)
        return documentsDirectoryURL
    }()
    
    class func nextBingoCardDocPath() -> URL? {
        // 1
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: privateDocsDir,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles) else { return nil }
        
        var maxNumber = 0
        
        // 2
        files.forEach {
            if $0.pathExtension == "bingocards" {
                let fileName = $0.deletingPathExtension().lastPathComponent
                maxNumber = max(maxNumber, Int(fileName) ?? 0)
            }
        }
        
        // 3
        
        return privateDocsDir.appendingPathComponent(
            "\(maxNumber + 1).bingocards",
            isDirectory: true)
    }
    
    class func loadBingoCards() -> [BingoCard] {
        // 1
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: privateDocsDir,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles) else { return [] }
        
        return files
            .filter { $0.pathExtension == "bingocards" } // 2
            .map { BingoCard(docPath: $0) } // 3
    }
}
