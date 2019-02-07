//
//  Storage.swift
//  SavingPractice
//
//  Created by Deanna Lepke on 2019-02-02.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation

class Storage {
    
    fileprivate init() { }
    
    enum Directory {
        case documents
        case caches
    }
    
    static fileprivate func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
//        print("running store func")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
//            fatalError("File at path \(url.path) does not exist!")
            print("file doesn't exist")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
//                print(model)
                return model
            } catch {
//                fatalError(error.localizedDescription)
                print("no data to present")
                return nil
            }
        } else {
            print("no contents in bingocards folder")
            return nil
        }
    }
    
    static func retrieveAll<T: Decodable>(_ directoryName: String, from directory: Directory, as type: T.Type) -> [BingoCard] {
        var bingoCardArray: [BingoCard] = []
        
        let testDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("BingoCards")
        
//        print("removing: ", testDirectory.path)
        try? FileManager.default.removeItem(at: testDirectory)
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        print(directoryURL)
        
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
//            print("directory contents: ", directoryContents)
            for bingoCard in directoryContents {
//                print("bingocard lastpathcomponent: ", bingoCard.lastPathComponent)
                let bingoCardFile = Storage.retrieve(bingoCard.lastPathComponent, from: .documents, as: BingoCard.self)
//                print("bingoFile: ", bingoCardFile as Any)
                if bingoCardFile != nil {
//                    print("appending: ", bingoCardFile as Any)
                    bingoCardArray.append(bingoCardFile!)
//                    print("retrieving bingocard: ", bingoCardFile!.title)
                } else {
                    print("bingoCardFile was nil")
                    return bingoCardArray
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
//        print("retrieved these cards: ", bingoCardArray)
        return bingoCardArray
    }
    
    static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
