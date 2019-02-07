//
//  BingoCard.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-30.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class BingoCard: Codable {
    
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(freeSquare, forKey: .freeSquare)
        try container.encode(completionPoint, forKey: .completionPoint)
        try container.encode(contents, forKey: .contents)
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        freeSquare = try values.decode(Bool.self, forKey: .freeSquare)
        completionPoint = try values.decode(String.self, forKey: .completionPoint)
        contents = try values.decode([BoxContents].self, forKey: .contents)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case freeSquare
        case completionPoint
        case contents
    }
    
    init(title: String, freeSquare: Bool, completionPoint: String, contents: [BoxContents]) {
        self.title = title
        self.freeSquare = freeSquare
        self.completionPoint = completionPoint
        self.contents = contents
    }
    
    func saveCard() {
//        print("saving this card: ", self.title)
        
        Storage.store(self, to: .documents, as: self.title)
    }
}



