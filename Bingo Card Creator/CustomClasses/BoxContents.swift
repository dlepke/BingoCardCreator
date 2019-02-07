//
//  BoxContents.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-02-06.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import Foundation
import UIKit

class BoxContents: Codable {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
    var complete: Bool
    var proof: UIImage?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(boxTitle, forKey: .boxTitle)
        try container.encode(boxDetails, forKey: .boxDetails)
        try container.encode(proofRequired, forKey: .proofRequired)
        try container.encode(complete, forKey: .complete)
        
        if proof != nil {
            let proofData: Data = proof!.pngData()!
            let strBase64 = proofData.base64EncodedString(options: .lineLength64Characters)
            try container.encode(strBase64, forKey: .proof)
        } else {
            try container.encode("", forKey: .proof)
        }
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        boxTitle = try values.decode(String.self, forKey: .boxTitle)
        boxDetails = try values.decode(String.self, forKey: .boxDetails)
        proofRequired = try values.decode(String.self, forKey: .proofRequired)
        complete = try values.decode(Bool.self, forKey: .complete)
        
        let strBase64 = try values.decode(String.self, forKey: .proof)
        let proofDataDecoded: Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        proof = UIImage(data: proofDataDecoded)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case boxTitle
        case boxDetails
        case proofRequired
        case complete
        case proof
    }
    
    init(boxTitle: String, boxDetails: String, proofRequired: String, complete: Bool, proof: UIImage?) {
        self.boxTitle = boxTitle
        self.boxDetails = boxDetails
        self.proofRequired = proofRequired
        self.complete = complete
        self.proof = proof
    }
}
