//
//  BingoBox.swift
//  Bingo Card Creator
//
//  Created by Deanna Lepke on 2019-01-17.
//  Copyright © 2019 Deanna Lepke. All rights reserved.
//

import UIKit

class BingoBox: UICollectionViewCell {
    
    @IBOutlet weak var bingoBoxTitle: UILabel!
    
    @IBOutlet weak var bingoBoxActionIcon: UIImageView!
    
}

struct BoxContents {
    var boxTitle: String
    var boxDetails: String
    var proofRequired: String
}

struct BingoCard {
    var title: String
    var freeSquare: Bool
    var completionPoint: String
    var contents: [BoxContents]
}


let sampleBoxContents = [
    BoxContents(boxTitle: "Box One", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Two", boxDetails: "Hi Friend, I have no details", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Three", boxDetails: "If I had details, they would go here", proofRequired: "none"),
    BoxContents(boxTitle: "Box Four", boxDetails: "", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Five", boxDetails: "", proofRequired: "camera"),
    
    BoxContents(boxTitle: "Box Six", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Seven", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Eight", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Nine", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Ten", boxDetails: "", proofRequired: "camera"),
    
    BoxContents(boxTitle: "Box Eleven", boxDetails: "", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Twelve", boxDetails: "", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Thirteen", boxDetails: "", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Fourteen", boxDetails: "", proofRequired: "signature"),
    BoxContents(boxTitle: "Box Fifteen", boxDetails: "", proofRequired: "signature"),
    
    BoxContents(boxTitle: "Box Sixteen", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Seventeen", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Eighteen", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Nineteen", boxDetails: "", proofRequired: "camera"),
    BoxContents(boxTitle: "Box Twenty", boxDetails: "", proofRequired: "camera"),
    
    BoxContents(boxTitle: "Box Twenty-One", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Twenty-Two", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Twenty-Three", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Twenty-Four", boxDetails: "", proofRequired: "none"),
    BoxContents(boxTitle: "Box Twenty-Five", boxDetails: "", proofRequired: "none"),
]


var sampleCard = BingoCard(
    title: "Sample Card",
    freeSquare: true,
    completionPoint: "Whole Card",
    contents: sampleBoxContents
)
