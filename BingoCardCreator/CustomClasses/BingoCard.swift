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
    let positionInCard: Float
    let complete: Bool
    
    init(boxTitle: String, positionInCard: Float, complete: Bool) {
        self.boxTitle = boxTitle
        self.positionInCard = positionInCard
        self.complete = complete
    }
    
    enum CodingKeys: String, CodingKey {
        case boxTitle
        case positionInCard
        case complete
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boxTitle, forKey: .boxTitle)
        try container.encode(positionInCard, forKey: .positionInCard)
        try container.encode(complete, forKey: .complete)
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        boxTitle = try values.decode(String.self, forKey: .boxTitle)
        positionInCard = try values.decode(Float.self, forKey: .positionInCard)
        complete = try values.decode(Bool.self, forKey: .complete)
    }
}
